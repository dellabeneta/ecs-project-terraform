# --- ECS Cluster ---
resource "aws_ecs_cluster" "main" {
  name = "ecs-demo-cluster"

  tags = {
    Name = "ecs-demo-cluster"
  }
}

# --- Launch Template for ECS Instances ---
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-demo-lt-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [data.terraform_remote_state.network.outputs.ecs_tasks_security_group_id]
  }

  # Script para registrar a instância no cluster ECS correto
  user_data = base64encode(<<-EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ecs-demo-launch-template"
  }
}

# --- Auto Scaling Group for ECS Instances ---
resource "aws_autoscaling_group" "ecs_asg" {
  name                = "ecs-demo-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  
  # As instâncias serão lançadas nas sub-redes públicas para este exemplo
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  # Garante que o ASG funcione corretamente com o ECS
  service_linked_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "Name"
    value               = "ecs-demo-instance"
    propagate_at_launch = true
  }
}
