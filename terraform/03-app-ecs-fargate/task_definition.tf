# --- ECS Task Definition for Fargate ---
resource "aws_ecs_task_definition" "app_fargate" {
  family                   = "ecs-fargate-app-demo-task"
  network_mode             = "awsvpc" # Obrigatório para Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # 0.25 vCPU
  memory                   = "512"  # 0.5 GB - Fargate tem requisitos mínimos de memória por vCPU
  execution_role_arn       = aws_iam_role.ecs_fargate_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-fargate-app-demo-container",
      image     = aws_ecr_repository.fargate_app_repo.repository_url, # Imagem do novo repositório
      essential = true,
      portMappings = [
        {
          containerPort = 8080,
          protocol      = "tcp"
        }
      ],
      memory = 512,
      cpu    = 256
    }
  ])

  tags = {
    Name = "ecs-fargate-app-demo-task"
  }
}
