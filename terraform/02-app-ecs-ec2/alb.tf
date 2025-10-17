# --- Application Load Balancer ---
resource "aws_lb" "main" {
  name               = "ecs-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.network.outputs.lb_security_group_id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids

  tags = {
    Name = "ecs-demo-alb"
  }
}

# --- Target Group ---
resource "aws_lb_target_group" "app" {
  name        = "ecs-demo-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  target_type = "instance" # Nossas tarefas rodam em instâncias EC2

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs-demo-app-tg"
  }
}

# --- Listener ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
