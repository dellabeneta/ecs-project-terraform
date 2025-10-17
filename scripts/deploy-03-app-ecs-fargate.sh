#!/bin/bash
# Script para implantar/destruir a camada da Aplicação (ECS Fargate, ALB, etc.)

set -e

# Carrega as configurações centralizadas, como o perfil da AWS.
source "$(dirname "$0")/config.sh"

ACTION=${1:-apply} # Default to 'apply' if no argument is given

# Navega para a pasta correta
cd terraform/03-app-ecs-fargate

# Inicializa o Terraform
echo "--- Camada 03-app-ecs-fargate: Executando terraform init ---"
terraform init

# Executa a ação (apply ou destroy)
if [ "$ACTION" = "destroy" ]; then
  echo "--- Camada 03-app-ecs-fargate: Executando terraform destroy ---"
  terraform destroy -auto-approve
  echo "--- Camada da Aplicação (Fargate) destruída com sucesso! ---"
else
  echo "--- Camada 03-app-ecs-fargate: Executando terraform apply ---"
  terraform apply -auto-approve
  echo "--- Camada da Aplicação (Fargate) implantada com sucesso! ---"
fi