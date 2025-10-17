# Usar uma imagem base oficial do Python
FROM python:3.9-slim

# Definir o diretório de trabalho no container
WORKDIR /app

# Copiar o arquivo de dependências e instalar as dependências
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código da aplicação para o diretório de trabalho
COPY app/ .

# Expor a porta que a aplicação usa
EXPOSE 8080

# Comando para rodar a aplicação
CMD ["python", "main.py"]
