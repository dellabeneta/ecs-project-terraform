# Legenda do Diagrama de Arquitetura

Esta legenda explica os estilos visuais (cores e setas) utilizados no [diagrama de arquitetura principal](../README.md).

---

### Cores dos Blocos (Tipos de Componentes)

As cores agrupam os recursos por sua função principal no ecossistema.

- **Azul (Usuário):** Representa o ator externo, ou seja, o usuário final que acessa a aplicação.
- **Laranja (Cloudflare):** Representa os serviços da Cloudflare, que atuam como a camada de borda (DNS e Proxy).
- **Laranja Queimado (Rede):** Componentes de rede da AWS, responsáveis por rotear e distribuir o tráfego (ALB, NAT Gateway, Internet Gateway).
- **Azul Claro (Computação):** Onde a aplicação efetivamente roda (Instâncias EC2, Tarefas Fargate, Auto Scaling Group).
- **Verde (Orquestração):** Serviços que gerenciam a aplicação, mas não rodam o código diretamente (ECS Cluster, ECS Service).
- **Amarelo (Armazenamento):** Serviços de armazenamento, como o ECR (Elastic Container Registry) que guarda a imagem Docker.

---

### Estilos das Setas (Tipos de Conexão)

As setas foram estilizadas para diferenciar os principais tipos de fluxo de dados.

- **Seta Azul Sólida:** Representa o **fluxo principal da requisição do usuário**. É o caminho que os dados fazem desde o navegador até serem entregues ao Load Balancer pela Cloudflare.
- **Seta Laranja Sólida:** Representa o **tráfego interno da aplicação**. É o caminho que a requisição faz do Load Balancer até a tarefa (EC2 ou Fargate) que está rodando a aplicação.
- **Seta Verde Tracejada:** Representa o **tráfego de suporte ou de saída**. Isso inclui o acesso à internet que as tarefas precisam para baixar a imagem Docker do ECR ou para acessar outras APIs públicas.
