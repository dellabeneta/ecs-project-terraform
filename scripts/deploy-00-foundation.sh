#!/bin/bash
# Script para implantar/destruir a camada de Fundação (Backend S3)

set -e

# Carrega as configurações centralizadas, como o perfil da AWS.
source "$(dirname "$0")/config.sh"

ACTION=${1:-apply} # Default to 'apply' if no argument is given

# Navega para a pasta correta
cd terraform/00-foundation

# Inicializa o Terraform
echo "--- Camada 00-foundation: Executando terraform init ---"
terraform init

# Executa a ação (apply ou destroy)
if [ "$ACTION" = "destroy" ]; then
  echo "--- Camada 00-foundation: Executando terraform destroy ---"
  terraform destroy -auto-approve
  echo "--- Camada de Fundação destruída com sucesso! ---"
else
  echo "--- Camada 00-foundation: Executando terraform apply ---"
  terraform apply -auto-approve
  echo "--- Camada de Fundação implantada com sucesso! ---"
fi