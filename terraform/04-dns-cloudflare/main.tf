
# Cria o registro DNS para o ambiente EC2
resource "cloudflare_record" "ecs_ec2_dns" {
  zone_id = var.cloudflare_zone_id
  name    = "ec2"
  content = data.terraform_remote_state.ecs_ec2.outputs.alb_dns_name
  type    = "CNAME"
  proxied = true # Habilita o proxy do Cloudflare (CDN, SSL, etc.)
  ttl     = 1      # TTL automático

  comment = "DNS for the ECS EC2 application ALB"
}

# Cria o registro DNS para o ambiente Fargate
resource "cloudflare_record" "ecs_fargate_dns" {
  zone_id = var.cloudflare_zone_id
  name    = "fargate"
  content = data.terraform_remote_state.ecs_fargate.outputs.alb_dns_name
  type    = "CNAME"
  proxied = true # Habilita o proxy do Cloudflare (CDN, SSL, etc.)
  ttl     = 1      # TTL automático

  comment = "DNS for the ECS Fargate application ALB"
}

# Outputs
output "ec2_hostname" {
  description = "Hostname para a aplicação EC2 gerenciado pelo Cloudflare."
  value       = cloudflare_record.ecs_ec2_dns.hostname
}

output "fargate_hostname" {
  description = "Hostname para a aplicação Fargate gerenciado pelo Cloudflare."
  value       = cloudflare_record.ecs_fargate_dns.hostname
}
