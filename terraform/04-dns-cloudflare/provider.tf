
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2" # A região deve ser a mesma das outras camadas
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
