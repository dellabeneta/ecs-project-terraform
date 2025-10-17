# Estimativa de Custos com Infracost

Este projeto utiliza o [Infracost](https://www.infracost.io/) para estimar os custos da infraestrutura provisionada via Terraform. Para mais detalhes, consulte a [documentação oficial do Infracost](https://www.infracost.io/docs/).

## 1. Pré-requisitos e Configuração

*   **Infracost CLI:** Instalado e autenticado. Você precisará de um token/API Key do Infracost (obtido via `infracost auth login`).
*   **AWS CLI:** Instalado.
*   **Perfil AWS:** A variável de ambiente `AWS_PROFILE` deve estar configurada no arquivo `scripts/config.sh` com o perfil correto (ex: `michel.dellabeneta`).

Para carregar o perfil AWS na sua sessão do terminal:

```bash
source scripts/config.sh
```

## 2. Fluxo de Trabalho Básico

Para estimar os custos de uma camada Terraform (ex: `01-network`):

```bash
# 1. Navegue para o diretório da camada
cd terraform/01-network # Ou qualquer outra camada

# 2. Inicialize o Terraform
terraform init

# 3. Execute o Infracost para a estimativa
infracost breakdown --path .
```

*   Use `infracost diff --path .` para ver a diferença de custo entre o estado atual e um plano com mudanças propostas.

## 3. Geração de Relatórios

Exporte os resultados para formatos como JSON ou HTML:

```bash
# Relatório JSON
infracost breakdown --path . --format json > infracost-report.json

# Relatório HTML
infracost breakdown --path . --format html --out-file infracost-report.html
```

## 4. Observações

*   As estimativas são baseadas em preços de lista e podem não incluir custos variáveis.
*   Sempre destrua recursos de teste para evitar custos inesperados.
