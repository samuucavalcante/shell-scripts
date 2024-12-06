
#!/bin/bash

# Caminho onde o arquivo docker-compose.yml e o .env devem estar
DIR=$(pwd)

# Verifica se o arquivo docker-compose.yml existe
if [ ! -f "$DIR/docker-compose.yml" ]; then
  echo "Arquivo docker-compose.yml não encontrado. Criando..."
  cat <<EOF > "$DIR/docker-compose.yml"
version: "3.8"

services:
  db:
    image: postgres:latest
    environment:
      - POSTGRES_USER=\${POSTGRES_USER}
      - POSTGRES_PASSWORD=\${POSTGRES_PASSWORD}
      - POSTGRES_DB=\${POSTGRES_DB}
    ports:
      - "\${POSTGRES_PORT}:\${POSTGRES_PORT}"
EOF
else
  # Caso o arquivo exista, verifica se o conteúdo já está lá
  if ! grep -q "version: \"3.8\"" "$DIR/docker-compose.yml"; then
    echo "Adicionando configuração ao docker-compose.yml..."
    echo -e "\nversion: \"3.8\"\n\nservices:\n  db:\n    image: postgres:latest\n    environment:\n      - POSTGRES_USER=\${POSTGRES_USER}\n      - POSTGRES_PASSWORD=\${POSTGRES_PASSWORD}\n      - POSTGRES_DB=\${POSTGRES_DB}\n    ports:\n      - \"\${POSTGRES_PORT}:\${POSTGRES_PORT}\"" >> "$DIR/docker-compose.yml"
  fi
fi

# Verifica se o arquivo .env existe
if [ ! -f "$DIR/.env" ]; then
  echo "Arquivo .env não encontrado. Criando..."
  cat <<EOF > "$DIR/.env"
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secret
POSTGRES_DB=postgres
POSTGRES_PORT=5432
POSTGRES_HOST=localhost
EOF
else
  # Caso o arquivo .env exista, verifica se os valores já estão lá
  if ! grep -q "POSTGRES_USER=" "$DIR/.env"; then
    echo "Adicionando configuração ao .env..."
    echo -e "\nPOSTGRES_USER=postgres\nPOSTGRES_PASSWORD=secret\nPOSTGRES_DB=postgres\nPOSTGRES_PORT=5432\nPOSTGRES_HOST=localhost" >> "$DIR/.env"
  fi
fi

echo "Script executado com sucesso!"
