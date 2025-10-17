# --- Security Groups ---
resource "aws_security_group" "lb" {
  name        = "ecs-demo-lb-sg"
  description = "Allow HTTP inbound traffic for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-demo-lb-sg"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-demo-tasks-sg"
  description = "Allow inbound traffic from the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow all traffic from the ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # "-1" significa "todos os protocolos"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-demo-tasks-sg"
  }
}
