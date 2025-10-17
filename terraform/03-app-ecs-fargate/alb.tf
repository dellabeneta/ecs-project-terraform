# --- Application Load Balancer for Fargate Service ---
resource "aws_lb" "fargate" {
  name               = "ecs-fargate-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.network.outputs.lb_security_group_id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids

  tags = {
    Name = "ecs-fargate-demo-alb"
  }
}

# --- Target Group for Fargate Service ---
resource "aws_lb_target_group" "fargate_app" {
  name        = "ecs-fargate-demo-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  target_type = "ip" # Obrigatório para Fargate

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
    Name = "ecs-fargate-demo-app-tg"
  }
}

# --- Listener for Fargate Service ---
resource "aws_lb_listener" "fargate_http" {
  load_balancer_arn = aws_lb.fargate.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_app.arn
  }
}
