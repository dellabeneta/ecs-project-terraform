# --- ECS Task Definition ---
resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-app-demo-task"
  network_mode             = "bridge" # Modo de rede para EC2 com ALB
  requires_compatibilities = ["EC2"]
  cpu                      = "256"  # 0.25 vCPU
  memory                   = "128"  # 128 MiB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-app-demo-container",
      image     = aws_ecr_repository.ec2_app_repo.repository_url,
      essential = true,
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 0 # Permite que o ECS escolha uma porta dinamicamente
        }
      ],
      memory = 128,
      cpu    = 256
    }
  ])

  tags = {
    Name = "ecs-app-demo-task"
  }
}

# --- ECS Service ---
resource "aws_ecs_service" "main" {
  name            = "ecs-demo-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2 # Iniciar com 2 instâncias do nosso container

  launch_type = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "ecs-app-demo-container"
    container_port   = 8080
  }

  # Garante que não teremos indisponibilidade durante os deploys
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # Dependência para garantir que o Listener do ALB esteja pronto
  depends_on = [aws_lb_listener.http]

  tags = {
    Name = "ecs-demo-service"
  }
}
