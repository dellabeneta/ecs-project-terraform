terraform {
  backend "s3" {
    bucket         = "ecs-project-demo-tfstate"
    key            = "app-ecs-ec2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ecs-project-demo-tf-lock-table"
  }
}
