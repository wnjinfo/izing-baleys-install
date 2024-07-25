## CRIAR SUBDOMINIO E APONTAR PARA O IP DA SUA VPS

Requisitos

Ubuntu 20 com minimo 8GB memoria
2 dns do backend e do frontend


## CHECAR PROPAGAÇÃO DO DOMÍNIO

https://dnschecker.org/

## ACESSO ##
Front:
```bash
http://seuipinterno:4000
```

Back:
```bash
http://seuipinterno:3000
```

Usuario:
```bash
admin@izing.io
```

Senha:
```bash
123456
```

## RODAR OS COMANDOS ABAIXO ##

para evitar erros recomendados atualizar sistema e apos atualizar reniciar para evitar erros

Primeiro crie senha para o sudo
```bash
sudo passwd root
```

Depois logar como sudo
```bash
sudo su
```

Atualizar sistema
```bash
apt -y update && apt -y upgrade
```

Reiniciar
```bash
reboot
```
 
Depois reniciar seguir com a instalacao
```bash
sudo su
```
```bash
apt install git
```
```bash
cd /root
```
```bash
git clone https://github.com/wnjinfo/izing-baleys-install.git izinginstalador
```
Editar dados com seus dados, com vim para salvar aperta ESC, depois wq! e de enter.
```bash
vim ./izinginstalador/config
```
```bash
sudo chmod +x ./izinginstalador/izing
```
```bash
cd ./izinginstalador
```
```bash
sudo ./izing
```

## RODAR OS COMANDOS ABAIXO PARA ATUALIZAR

```bash
cd /root
```
```bash
cd ./izinginstalador
```
```bash
sudo ./izing
```


## Problemas conexão whatsapp? ##

Tente atualizar o Conector WWebJS whatsapp.js


## Alterar Frontend

Para mudar nome do aplicativo:

/home/deploy/izing/frontend/quasar.conf

/home/deploy/izing/frontend/src/index.template.html

Para alterar logos e icones:

pasta /home/deploy/izing/frontend/public

Para alterar cores:

/home/deploy/izing/frontend/src/css/app.sass

/home/deploy/izing/frontend/src/css/quasar.variables.sass

Sempre alterar usando usuario deploy você pode conectar servidor com aplicativo Bitvise SSH Client. Depois das alterações compilar novamente o Frontend

```bash
su deploy
```
```bash
cd /home/deploy/izing/frontend/
```
```bash
npm run build
```

Testar as alterações em aba anonima

## Erros

Caso não inicie na primeira instalação use opção 2 para atualizar pode ser algum arquivo não baixou corretamente

"Internal server error: SequelizeConnectionError: could not open file \"global/pg_filenode.map\": Permission denied"

```bash
docker container restart postgresql
```
```bash
docker exec -u root postgresql bash -c "chown -R postgres:postgres /var/lib/postgresql/data"
```
```bash
docker container restart postgresql
```


## Problemas enviar audios e noticações

Isso porque você não possui certificado quando roda localmente consideram a conexão como insegura e bloqueiam o microfone.

Você consegue resolver isto, acessando o link dentro do navegador Chrome; chrome://flags/#unsafely-treat-insecure-origin-as-secure e inserindo o ip com porta do seu frontend e backend.

## Acesso Portainer gerar senha
"Your Portainer instance timed out for security purposes. To re-enable your Portainer instance, you will need to restart Portainer."

```bash
docker container restart portainer
```

Depois acesse novamente url http://seuip:9000/

