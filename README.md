---------------S2---------------

            TERRAFORM

Esse é o meu projeto usando o Terraform para subir uma infraestrutura na NUVEM AWS

Para que funcione é necessário que os dois arquivos fiquem na mesma pasta.


Breve descrição:

Esse código irá criar na Região N. Virgínia:
    1 VPC
    1 Subnet Privada
    1 Subnet Pública
    1 IGW
    1 NAT Gateway
    2 EIPS
    1 Tabela de rotas apontando ao IGW
    1 EC2 privada
    1 EC2 pública
    Grupos de segurança etc...

É importante lembrar que o controle estado será remoto, em vez de ser local.

    E é por isso que coloquei como back-end do Terraform um Bucket S3 com versionamento habilitado.


Por fim temos variáveis que serão usadas no decorrer do código.

---------------S2---------------