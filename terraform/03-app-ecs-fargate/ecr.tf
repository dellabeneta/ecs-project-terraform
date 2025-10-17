resource "aws_ecr_repository" "fargate_app_repo" {
  name = "ecs-app-demo-fargate-repo"

  # Impede que o Terraform delete o repositório se ele contiver imagens.
  force_delete = true

  tags = {
    Name = "ecs-app-demo-fargate-repo"
  }
}

output "ecr_repository_url" {
  description = "A URL do repositório ECR para a aplicação Fargate"
  value       = aws_ecr_repository.fargate_app_repo.repository_url
}
