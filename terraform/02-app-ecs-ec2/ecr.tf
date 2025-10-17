resource "aws_ecr_repository" "ec2_app_repo" {
  name = "ecs-app-demo-ec2-repo"

  # Impede que o Terraform delete o repositório se ele contiver imagens.
  force_delete = true

  tags = {
    Name = "ecs-app-demo-ec2-repo"
  }
}

output "ecr_repository_url" {
  description = "A URL do repositório ECR"
  value       = aws_ecr_repository.ec2_app_repo.repository_url
}
