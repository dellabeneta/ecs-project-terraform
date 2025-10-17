# Camada 00: Foundation

## Objetivo

Esta camada é responsável por provisionar a infraestrutura fundamental e pré-requisito para todas as outras camadas do projeto. Ela cria os recursos necessários para o gerenciamento centralizado e seguro do estado do Terraform (remote state).

## Recursos Principais Criados

- **`aws_s3_bucket`**: Cria um bucket S3 privado e seguro que será usado como backend para armazenar os arquivos de estado (`.tfstate`) do Terraform.
- **`aws_s3_bucket_*`**: Recursos auxiliares que configuram o bucket com versionamento, criptografia AES256 e bloqueio de acesso público.
- **`aws_dynamodb_table`**: Cria uma tabela no DynamoDB para funcionar como mecanismo de lock, prevenindo a execução simultânea de operações de escrita no estado e garantindo a consistência.

## Dependências

Esta é a camada base e não possui dependências de outras camadas.

## Saídas (Outputs)

Esta camada não exporta saídas, pois seus recursos (bucket e tabela do DynamoDB) são referenciados diretamente na configuração de `backend` das outras camadas, e não como `data sources`.

---

### Nota Importante sobre Nomes de Recursos

Os nomes do bucket S3 e da tabela DynamoDB são definidos no arquivo `main.tf` desta camada. Atualmente, eles usam o nome genérico `ecs-project-demo-tfstate`.

Como esses nomes precisam ser **globalmente únicos** na AWS, se você estiver adaptando este projeto, **é crucial que você altere esses nomes** para algo único para sua conta, a fim de evitar conflitos de deploy.
