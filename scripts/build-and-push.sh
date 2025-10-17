#!/bin/bash
# Script para construir a imagem Docker, taguear e enviar para o Amazon ECR.
# USO: ./scripts/build-and-push.sh [ec2|fargate]

set -e

# --- Validação do Argumento ---
if [ -z "$1" ] || ( [ "$1" != "ec2" ] && [ "$1" != "fargate" ] ); then
  echo "ERRO: Forneça o ambiente como argumento."
  echo "Uso: $0 [ec2|fargate]"
  exit 1
fi

ENV_TYPE=$1
TERRAFORM_APP_DIR=""

if [ "$ENV_TYPE" == "ec2" ]; then
  TERRAFORM_APP_DIR="terraform/02-app-ecs-ec2"
elif [ "$ENV_TYPE" == "fargate" ]; then
  TERRAFORM_APP_DIR="terraform/03-app-ecs-fargate"
fi

echo "--- Iniciando Build e Push da Imagem Docker para o ambiente '$ENV_TYPE' ---"

# Carrega as configurações centralizadas, como o perfil da AWS.
source "$(dirname "$0")/config.sh"

# --- Configurações ---
AWS_REGION="us-east-2"
IMAGE_NAME="ecs-app-demo" # O nome da imagem pode ser o mesmo para ambos

# 1. Obter a URL do repositório ECR a partir do output do Terraform
echo "Obtendo a URL do ECR do estado do Terraform em '$TERRAFORM_APP_DIR'..."

# A flag -raw retorna o valor puro, sem aspas
ECR_URL=$(cd "$TERRAFORM_APP_DIR" && terraform output -raw ecr_repository_url && cd - > /dev/null)

if [ -z "$ECR_URL" ]; then
    echo "ERRO: Não foi possível obter a URL do ECR."
    echo "Você já executou o script de deploy para o ambiente '$ENV_TYPE' ($TERRAFORM_APP_DIR)?"
    exit 1
fi

echo "URL do Repositório ECR: $ECR_URL"

# 2. Autenticar o Docker no ECR
echo "Autenticando o Docker no ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

# 3. Construir a imagem Docker a partir da raiz do projeto
echo "Construindo a imagem Docker..."
# O Dockerfile está na raiz, então o contexto de build é '.'
docker build -t $IMAGE_NAME .

# 4. Taguear a imagem para o ECR
echo "Tagueando a imagem como 'latest'..."
docker tag ${IMAGE_NAME}:latest ${ECR_URL}:latest

# 5. Enviar a imagem para o ECR
echo "Enviando a imagem para o ECR..."
docker push ${ECR_URL}:latest

echo "--- Imagem enviada com sucesso para o ECR! ---"
