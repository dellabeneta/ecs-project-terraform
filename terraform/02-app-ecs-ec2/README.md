# Camada 02: Aplicação ECS (EC2)

## Objetivo

Esta camada é responsável por fazer o deploy da aplicação containerizada em um cluster Amazon ECS utilizando o **Launch Type EC2**. Isso significa que o cluster será composto por instâncias EC2 (Máquinas Virtuais) que nós gerenciamos através de um Auto Scaling Group.

## Recursos Principais Criados

- **`aws_ecr_repository`**: Cria um repositório no Elastic Container Registry (ECR) para armazenar a imagem Docker da aplicação.
- **`aws_ecs_cluster`**: Cria o cluster ECS, que é um agrupamento lógico dos nossos recursos.
- **`aws_launch_template` & `aws_autoscaling_group`**: Configuram e gerenciam um grupo de instâncias EC2 (`t2.micro`) que se registrarão automaticamente no cluster ECS para executar as tarefas. As instâncias são posicionadas nas sub-redes privadas por segurança.
- **`aws_iam_role`**: Define as permissões necessárias para que as instâncias EC2 e as tarefas ECS possam interagir com outros serviços AWS (como ECR e CloudWatch).
- **`aws_ecs_task_definition`**: Descreve o container que será executado: qual imagem Docker usar (`ecr_repository_url`), quanta CPU e memória alocar, e o mapeamento de portas.
- **`aws_ecs_service`**: Mantém o número desejado de instâncias da `Task Definition` sempre em execução. Ele também é responsável por registrar as tarefas no Application Load Balancer para que recebam tráfego.
- **`aws_lb` (ALB)**: Cria um Application Load Balancer para distribuir o tráfego HTTP de entrada entre as tarefas da aplicação de forma balanceada.
- **`aws_lb_target_group` & `aws_lb_listener`**: Configuram o ALB para encaminhar o tráfego da porta 80 para os containers na porta 8080 e monitorar a saúde da aplicação.

## Dependências

- **Camada 01 (Network)**: Utiliza o `terraform_remote_state` para obter os IDs da VPC, sub-redes e security groups, posicionando os recursos de aplicação na rede correta.
- **Backend S3**: Utiliza o backend S3 configurado na **Camada 00** para armazenamento do estado.

## Saídas (Outputs)

- **`ecr_repository_url`**: A URL do repositório ECR criado, a ser usada no script de build e push da imagem Docker.
- **`alb_dns_name`**: O endereço DNS público do Application Load Balancer, que é o ponto de entrada para acessar a aplicação.
