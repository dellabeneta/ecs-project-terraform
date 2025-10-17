# --- Data source to get the latest ECS-optimized AMI ---
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# --- Data source to get current AWS Account ID ---
data "aws_caller_identity" "current" {}

# --- Remote State to get Network resources ---
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "ecs-project-demo-tfstate"
    key     = "network/terraform.tfstate"
    region  = "us-east-2"
  }
}
