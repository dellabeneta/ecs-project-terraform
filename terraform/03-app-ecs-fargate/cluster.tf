# --- ECS Cluster ---
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "ecs-fargate-demo-cluster"

  tags = {
    Name = "ecs-fargate-demo-cluster"
  }
}
