terraform {
  backend "s3" {
    bucket     = "marymarybucketteste"
    key        = "dev/terraform.tfstate"
    region     = "us-east-1"
    access_key = "AQUI COLOQUE A SUA CHAVE DA SUA CONTA AWS"
    secret_key = "AQUI COLOQUE A SUA CHAVE DA SUA CONTA AWS"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AQUI COLOQUE A SUA CHAVE DA SUA CONTA AWS"
  secret_key = "AQUI COLOQUE A SUA CHAVE DA SUA CONTA AWS"
}

resource "aws_s3_bucket" "marymarybucketteste" {
  bucket = "marymarybucketteste"
}

# Create a VPC
resource "aws_vpc" "vpc-atlas-padrao" {
  cidr_block           = var.blocos[0]
  enable_dns_hostnames = true
  tags = {
    Dev = "Development - vpc"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = aws_vpc.vpc-atlas-padrao.id
  cidr_block        = var.Range[0]
  availability_zone = "us-east-1a"
  tags = {
    Dev = "Development - private"
  }

}

resource "aws_subnet" "public-subnet-a" {
  vpc_id            = aws_vpc.vpc-atlas-padrao.id
  cidr_block        = var.Range[1]
  availability_zone = "us-east-1a"
  tags = {
    Dev = "Development - public"
  }

}

resource "aws_eip" "elastic-ip" {
  vpc = true
  tags = {
    Name = "Elastic IP"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}


resource "aws_eip" "elastic" {
  vpc = true
  tags = {
    Name = "elastic"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-atlas-padrao.id
  tags = {
    Name = "IGW ATLAS"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.private-subnet-a.id
  tags = {
    Name = "NAT ATLAS"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]

}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2-teste.id
  allocation_id = aws_eip.elastic.id
}

resource "aws_route_table" "tabela-de-rota" {
  vpc_id = aws_vpc.vpc-atlas-padrao.id
  tags = {
    Dev = "TABLE ATLAS"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "assoc-table" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.tabela-de-rota.id
}

# Create a EC2
resource "aws_instance" "ec2-atlas" {
  ami                     = var.amis[0]
  instance_type           = "t2.micro"
  count                   = 1
  disable_api_termination = false
  subnet_id               = aws_subnet.private-subnet-a.id
  security_groups         = [aws_security_group.gruposec.id]
  key_name                = "key-mary"
  tags = {
    Dev = "Development EC2"
  }
}


resource "aws_security_group" "gruposec" {
  description = "Acesso ao ssh http https"
  vpc_id      = aws_vpc.vpc-atlas-padrao.id
  name        = "testandomaria"
  ingress {
    cidr_blocks = [var.groupnumber[5]]
    from_port   = var.groupnumber[0]
    protocol    = var.groupnumber[1]
    to_port     = var.groupnumber[0]
  }
  ingress {
    cidr_blocks = [var.groupnumber[5]]
    from_port   = var.groupnumber[2]
    protocol    = var.groupnumber[1]
    to_port     = var.groupnumber[2]
  }
}

resource "aws_instance" "ec2-teste" {
  ami           = var.amis[0]
  instance_type = "t2.micro"
  #count                   = 1
  disable_api_termination = false
  subnet_id               = aws_subnet.public-subnet-a.id
  security_groups         = [aws_security_group.gruposec.id]
  key_name                = "key-mary"
  tags = {
    Dev = "Development EC2"
  }
}
