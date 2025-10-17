# Camada 04: DNS (Cloudflare)

## Descrição

Esta camada é responsável por gerenciar os registros DNS da aplicação utilizando o provedor Terraform da Cloudflare. Ela cria registros `CNAME` que apontam para os Application Load Balancers (ALBs) criados nas camadas de aplicação (`02-app-ecs-ec2` e `03-app-ecs-fargate`), permitindo o acesso à aplicação através de subdomínios amigáveis.

## Recursos Criados

- **`cloudflare_record` (x2)**: Cria dois registros DNS do tipo `CNAME`:
  - `ec2.<seu_dominio>` -> Aponta para o ALB do ambiente EC2.
  - `fargate.<seu_dominio>` -> Aponta para o ALB do ambiente Fargate.

## Configuração

Antes de aplicar esta camada, é essencial configurar as seguintes variáveis no arquivo `scripts/config.sh`:

```bash
# --- Configurações do Cloudflare ---
# Token de API com permissão para editar DNS da zona desejada.
export CLOUDFLARE_API_TOKEN="seu-token-aqui"

# Zone ID do seu domínio no Cloudflare.
export CLOUDFLARE_ZONE_ID="seu-zone-id-aqui"

# Nome do domínio principal que você está configurando (ex: seudominio.com).
export CLOUDFLARE_DOMAIN_NAME="seudominio.com"
```

- **`CLOUDFLARE_API_TOKEN`**: Para gerar um token, vá em `My Profile > API Tokens > Create Token` no painel da Cloudflare. Use o template `Edit zone DNS` e garanta que ele tenha a permissão `Zone:DNS:Edit` para o domínio desejado.
- **`CLOUDFLARE_ZONE_ID`**: Pode ser encontrado na página de visão geral (overview) do seu domínio no painel da Cloudflare.

## Uso

Para aplicar esta camada, execute o script de deploy correspondente:

```bash
./scripts/deploy-04-dns-cloudflare.sh
```

Para destruir os recursos, use o mesmo script com o argumento `destroy`:

```bash
./scripts/deploy-04-dns-cloudflare.sh destroy
```

---

### Nota Crítica: Modo de Criptografia SSL/TLS e Erro 522

Esta camada, por padrão, assume que o Application Load Balancer na AWS está configurado para receber tráfego na porta **80 (HTTP)**.

Ao usar o proxy da Cloudflare (`proxied = true`), a conexão entre o navegador do cliente e a Cloudflare é sempre segura (HTTPS). No entanto, a conexão entre a Cloudflare e a sua origem (o ALB) depende do **Modo de Criptografia SSL/TLS** configurado no painel da Cloudflare (`SSL/TLS > Overview`).

- **Modo "Completo" (Full) ou "Completo (Estrito)"**: A Cloudflare tentará se conectar ao seu ALB na porta **443 (HTTPS)**. Como o ALB não está escutando nesta porta, a conexão falhará, resultando em um erro **`HTTP 522 Connection Timed Out`**.

- **Modo "Flexível" (Flexible)**: A Cloudflare se conectará ao seu ALB na porta **80 (HTTP)**. Como o Security Group do ALB permite tráfego nesta porta, a conexão funcionará corretamente.

**Para que esta camada funcione com a configuração atual do projeto, é obrigatório que o modo de criptografia do seu domínio na Cloudflare esteja definido como "Flexível".**
