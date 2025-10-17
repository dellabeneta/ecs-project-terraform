
variable "cloudflare_api_token" {
  description = "Token de API do Cloudflare para autenticação."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "ID da Zona do Cloudflare correspondente ao domínio."
  type        = string
}

variable "domain_name" {
  description = "Nome do domínio principal que você está configurando (ex: seudominio.com)."
  type        = string
}

variable "aws_profile" {
  description = "Perfil AWS para autenticação."
  type        = string
}
