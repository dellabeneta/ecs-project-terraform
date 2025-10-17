# --- IAM Role for Fargate Tasks ---
resource "aws_iam_role" "ecs_fargate_task_execution_role" {
  name = "ecs-fargate-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ecs-fargate-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_fargate_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_fargate_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
