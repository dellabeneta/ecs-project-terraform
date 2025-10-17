#!/bin/bash
# Script para implantar/destruir a camada de Rede (VPC, Subnets, etc.)

set -e

# Carrega as configurações centralizadas, como o perfil da AWS.
source "$(dirname "$0")/config.sh"

ACTION=${1:-apply} # Default to 'apply' if no argument is given

# Navega para a pasta correta
cd terraform/01-network

# Inicializa o Terraform
echo "--- Camada 01-network: Executando terraform init ---"
terraform init

# Executa a ação (apply ou destroy)
if [ "$ACTION" = "destroy" ]; then
  echo "--- Camada 01-network: Executando terraform destroy ---"
  terraform destroy -auto-approve
  echo "--- Camada de Rede destruída com sucesso! ---"
else
  echo "--- Camada 01-network: Executando terraform apply ---"
  terraform apply -auto-approve
  echo "--- Camada de Rede implantada com sucesso! ---"
fi