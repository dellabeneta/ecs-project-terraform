# Camada 01: Network

## Objetivo

Esta camada provisiona toda a infraestrutura de rede (Virtual Private Cloud - VPC) necessária para a aplicação. Ela cria uma separação lógica entre recursos públicos e privados, garantindo uma arquitetura segura e escalável.

## Recursos Principais Criados

- **`aws_vpc`**: Cria a VPC principal, um ambiente de rede isolado na nuvem AWS.
- **`aws_subnet`**: Define quatro sub-redes distribuídas em duas zonas de disponibilidade para alta disponibilidade:
  - Duas sub-redes **públicas**, para recursos que precisam de acesso direto à internet, como o Application Load Balancer.
  - Duas sub-redes **privadas**, para os recursos de backend, como as instâncias EC2 ou tarefas Fargate do ECS, que não devem ser expostas diretamente.
- **`aws_internet_gateway`**: Permite a comunicação entre a VPC e a internet.
- **`aws_nat_gateway`**: Permite que os recursos nas sub-redes privadas iniciem conexões de saída para a internet (ex: para baixar dependências), mas impede conexões de entrada não solicitadas.
- **`aws_eip`**: Aloca um IP elástico para o NAT Gateway.
- **`aws_route_table`**: Cria tabelas de rotas distintas para as sub-redes públicas (rota para o Internet Gateway) e privadas (rota para o NAT Gateway).
- **`aws_security_group`**: Define regras de firewall para controlar o tráfego:
  - Um Security Group para o **Load Balancer**, liberando a porta 80 (HTTP) para o mundo.
  - Um Security Group para as **Tarefas do ECS**, permitindo tráfego apenas a partir do Load Balancer.

## Dependências

Esta camada utiliza o backend S3 configurado na **Camada 00: Foundation** para armazenar seu arquivo de estado (`.tfstate`).

## Saídas (Outputs)

Esta camada exporta os seguintes dados para serem utilizados pelas camadas de aplicação:

- **`vpc_id`**: O ID da VPC criada.
- **`public_subnet_ids`**: A lista de IDs das sub-redes públicas.
- **`private_subnet_ids`**: A lista de IDs das sub-redes privadas.
- **`lb_security_group_id`**: O ID do Security Group do Load Balancer.
- **`ecs_tasks_security_group_id`**: O ID do Security Group para as tarefas/serviços do ECS.
- **`nat_gateway_eip`**: O endereço IP público do NAT Gateway.
