#!/bin/bash

# Carrega as configurações de perfil da AWS e Cloudflare
source "$(dirname "$0")/config.sh"

# Define o diretório do Terraform para esta camada
TERRAFORM_DIR="$(dirname "$0")/../terraform/04-dns-cloudflare"

# Cores para o output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# --- Validação das Variáveis ---
if [ -z "$AWS_PROFILE" ] || [ -z "$CLOUDFLARE_API_TOKEN" ] || [ -z "$CLOUDFLARE_ZONE_ID" ] || [ -z "$CLOUDFLARE_DOMAIN_NAME" ]; then
  echo "Erro: Uma ou mais variáveis necessárias não estão definidas em scripts/config.sh."
  echo "Verifique se AWS_PROFILE, CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID, e CLOUDFLARE_DOMAIN_NAME estão configurados."
  exit 1
fi

# Navega para o diretório do Terraform
cd "$TERRAFORM_DIR" || exit

# Inicializa o Terraform
echo -e "${GREEN}Executando terraform init...${NC}"
terraform init -reconfigure

# Passa as variáveis para o Terraform e executa a ação
VARS=(
  -var="cloudflare_api_token=$CLOUDFLARE_API_TOKEN"
  -var="cloudflare_zone_id=$CLOUDFLARE_ZONE_ID"
  -var="domain_name=$CLOUDFLARE_DOMAIN_NAME"
)

# Verifica se o primeiro argumento é 'destroy'
if [ "$1" == "destroy" ]; then
  echo -e "${GREEN}Executando terraform destroy...${NC}"
  terraform destroy -auto-approve "${VARS[@]}"
else
  echo -e "${GREEN}Executando terraform apply...${NC}"
  terraform apply -auto-approve "${VARS[@]}"
fi
