#!/bin/bash
# Script para implantar/destruir a camada da Aplicação (ECS, ALB, etc.)

set -e

# Carrega as configurações centralizadas, como o perfil da AWS.
source "$(dirname "$0")/config.sh"

ACTION=${1:-apply} # Default to 'apply' if no argument is given

# Navega para a pasta correta
cd terraform/02-app-ecs-ec2

# Inicializa o Terraform
echo "--- Camada 02-app-ecs-ec2: Executando terraform init ---"
terraform init

# Executa a ação (apply ou destroy)
if [ "$ACTION" = "destroy" ]; then
  echo "--- Camada 02-app-ecs-ec2: Executando terraform destroy ---"
  terraform destroy -auto-approve
  echo "--- Camada da Aplicação (EC2) destruída com sucesso! ---"
else
  echo "--- Camada 02-app-ecs-ec2: Executando terraform apply ---"
  terraform apply -auto-approve
  echo "--- Camada da Aplicação (EC2) implantada com sucesso! ---"
fi