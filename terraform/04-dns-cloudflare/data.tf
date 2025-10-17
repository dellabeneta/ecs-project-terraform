
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "ecs-project-demo-tfstate"
    key     = "network/terraform.tfstate"
    region  = "us-east-2"
  }
}

data "terraform_remote_state" "ecs_ec2" {
  backend = "s3"
  config = {
    bucket  = "ecs-project-demo-tfstate"
    key     = "app-ecs-ec2/terraform.tfstate"
    region  = "us-east-2"
  }
}

data "terraform_remote_state" "ecs_fargate" {
  backend = "s3"
  config = {
    bucket  = "ecs-project-demo-tfstate"
    key     = "app-ecs-fargate/terraform.tfstate"
    region  = "us-east-2"
  }
}
