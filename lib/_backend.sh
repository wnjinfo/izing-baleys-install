#!/bin/bash
# 
# functions for setting up app backend

#######################################
# creates docker db
# Arguments:
#   None
#######################################
backend_db_create() {
  print_banner
  printf "${WHITE} 💻 Criando banco de dados...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  mkdir -p /data
  chown -R 999:999 /data
  docker run --name postgresql \
                -e POSTGRES_USER=izing \
                -e POSTGRES_PASSWORD=${pg_pass} \
				-e TZ="America/Sao_Paulo" \
                -p 5432:5432 \
                --restart=always \
                -v /data:/var/lib/postgresql/data \
                -d postgres
  docker exec -u root postgresql bash -c "chown -R postgres:postgres /var/lib/postgresql/data"
  docker run --name redis-izing \
                -e TZ="America/Sao_Paulo" \
                -p 6379:6379 \
                --restart=always \
                -d redis:latest redis-server \
                --appendonly yes \
                --requirepass "${redis_pass}"

  docker run -d --name rabbitmq \
                -p 5672:5672 \
                -p 15672:15672 \
                --restart=always \
                --hostname rabbitmq \
                -e RABBITMQ_DEFAULT_USER=izing \
                -e RABBITMQ_DEFAULT_PASS=${rabbit_pass} \
                -v /data:/var/lib/rabbitmq \
                rabbitmq:3-management-alpine
  
  docker run -d --name portainer \
                -p 9000:9000 -p 9443:9443 \
                --restart=always \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v portainer_data:/data portainer/portainer-ce
EOF

  sleep 2
}

#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/izing.io/backend/.env
NODE_ENV=dev
BACKEND_URL=http://${ipservidorubuntu}
FRONTEND_URL=http://${ipservidorubuntu}:4000

PROXY_PORT=3000
PORT=3000

# conexão com o banco de dados
DB_DIALECT=postgres
DB_PORT=5432
DB_TIMEZONE=-03:00
POSTGRES_HOST=localhost
POSTGRES_USER=izing
POSTGRES_PASSWORD=${pg_pass}
POSTGRES_DB=postgres

# Chaves para criptografia do token jwt
JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

# Dados de conexão com o REDIS
IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD=${redis_pass}
IO_REDIS_PORT=6379
IO_REDIS_DB_SESSION=2

# tempo para randomização da mensagem de horário de funcionamento
MIN_SLEEP_BUSINESS_HOURS=1000
MAX_SLEEP_BUSINESS_HOURS=2000

# tempo para randomização das mensagens do bot
MIN_SLEEP_AUTO_REPLY=400
MAX_SLEEP_AUTO_REPLY=600

# tempo para randomização das mensagens gerais
MIN_SLEEP_INTERVAL=200
MAX_SLEEP_INTERVAL=500

# dados do RabbitMQ / Para não utilizar, basta comentar a var AMQP_URL
RABBITMQ_DEFAULT_USER=izing
RABBITMQ_DEFAULT_PASS=${rabbit_pass}
AMQP_URL='amqp://izing:${rabbit_pass}@localhost:5672?connection_attempts=5&retry_delay=5'

# api oficial (integração em desenvolvimento)
API_URL_360=https://waba-sandbox.360dialog.io

# usado para mosrar opções não disponíveis normalmente.
ADMIN_DOMAIN=izing.io

# Dados para utilização do canal do facebook
FACEBOOK_APP_ID=3237415623048660
FACEBOOK_APP_SECRET_KEY=3266214132b8c98ac59f3e957a5efeaaa13500

# Limitar Uso do Izing Usuario e Conexões
USER_LIMIT=99
CONNECTIONS_LIMIT=99
[-]EOF
EOF

  sleep 2
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing/backend
  npm install --force --silent
EOF

  sleep 2
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing/backend

EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing/backend
  npx sequelize db:migrate > /dev/null
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing/backend
  npx sequelize db:seed:all > /dev/null
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing/backend
  pm2 start dist/server.js --name izing-backend
  pm2 save
EOF

  sleep 2
}
