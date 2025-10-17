output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "lb_security_group_id" {
  description = "The ID of the load balancer's security group"
  value       = aws_security_group.lb.id
}

output "ecs_tasks_security_group_id" {
  description = "The ID of the ECS tasks' security group"
  value       = aws_security_group.ecs_tasks.id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "nat_gateway_eip" {
  description = "O Endereço IP Elástico do NAT Gateway"
  value       = aws_eip.nat.public_ip
}