terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Owner = "user@example.com"
    }
  }
}

output "alb_dns_name" {
  description = "O endereço DNS do Application Load Balancer para o serviço Fargate"
  value       = aws_lb.fargate.dns_name 
}
