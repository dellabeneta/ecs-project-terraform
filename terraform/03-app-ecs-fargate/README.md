# Camada 03: Aplicação ECS (Fargate)

## Objetivo

Esta camada é responsável por fazer o deploy da aplicação containerizada em um cluster Amazon ECS utilizando o **Launch Type Fargate**. O Fargate é a abordagem *serverless* para executar containers, onde a AWS gerencia toda a infraestrutura subjacente, eliminando a necessidade de provisionar e gerenciar servidores (instâncias EC2).

## Recursos Principais Criados

- **`aws_ecr_repository`**: Cria um repositório no Elastic Container Registry (ECR) dedicado para a imagem Docker da aplicação que rodará no Fargate.
- **`aws_ecs_cluster`**: Cria um cluster ECS para o ambiente Fargate.
- **`aws_iam_role`**: Define as permissões para que as tarefas Fargate possam puxar a imagem do ECR e se comunicar com outros serviços AWS.
- **`aws_ecs_task_definition`**: Descreve o container a ser executado. Para Fargate, é obrigatório usar o modo de rede `awsvpc`. A definição especifica a imagem Docker, os recursos de CPU e memória (com valores mínimos exigidos pelo Fargate), e as portas.
- **`aws_ecs_service`**: Mantém o número desejado de tarefas em execução. Diferente do modo EC2, aqui ele precisa de uma configuração de rede (`network_configuration`) para especificar em quais sub-redes (as privadas) e com qual security group as tarefas devem ser lançadas.
- **`aws_lb` (ALB)**: Cria um Application Load Balancer dedicado para o serviço Fargate, que irá distribuir o tráfego para as tarefas.
- **`aws_lb_target_group` & `aws_lb_listener`**: Configuram o ALB. Para Fargate, o `target_type` do Target Group deve ser `ip`, pois o Fargate atribui um IP de rede (ENI) para cada tarefa.

## Diferenças Chave (Fargate vs. EC2)

- **Gerenciamento de Infra**: Nenhuma instância EC2 ou Auto Scaling Group é criada. A AWS gerencia a computação.
- **Modo de Rede**: O modo `awsvpc` é mandatório, dando a cada tarefa sua própria interface de rede (ENI).
- **Target Group**: O tipo do Target Group do ALB deve ser `ip`.
- **Custo**: O modelo de custo é baseado na quantidade de vCPU e memória alocada para as tarefas, e não por instâncias EC2 ativas.

## Dependências

- **Camada 01 (Network)**: Utiliza o `terraform_remote_state` para obter os IDs da VPC, sub-redes privadas e security groups.
- **Backend S3**: Utiliza o backend S3 configurado na **Camada 00** para armazenamento do estado.

## Saídas (Outputs)

- **`ecr_repository_url`**: A URL do repositório ECR, a ser usada no script de build e push.
- **`alb_dns_name`**: O endereço DNS público do Load Balancer para acessar a aplicação via Fargate.
