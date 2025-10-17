# --- ECS Service for Fargate ---
resource "aws_ecs_service" "fargate_main" {
  name            = "ecs-fargate-demo-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.app_fargate.arn
  desired_count   = 2

  launch_type = "FARGATE"

  # A configuração de rede é obrigatória para o tipo Fargate
  network_configuration {
    subnets          = data.terraform_remote_state.network.outputs.private_subnet_ids
    security_groups  = [data.terraform_remote_state.network.outputs.ecs_tasks_security_group_id]
    assign_public_ip = false # As tarefas rodam em sub-redes privadas
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_app.arn
    container_name   = "ecs-fargate-app-demo-container"
    container_port   = 8080
  }

  # Garante que não teremos indisponibilidade durante os deploys
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # Dependência para garantir que o Listener do ALB esteja pronto
  depends_on = [aws_lb_listener.fargate_http]

  tags = {
    Name = "ecs-fargate-demo-service"
  }
}
