#!/bin/bash
# Install node packages
# Que se requieren en este directorio prueba-bitstarter-ssjs-db
npm install

echo -e "\n\nNOW ENTER YOUR HEROKU PASSWORD"
# Set up heroku.
# - devcenter.heroku.com/articles/config-vars
# - devcenter.heroku.com/articles/heroku-postgresql
heroku login
#Para versión simple, sólo con la rama de master
#heroku create
#Para versión con tres ramas develop, staging y production
heroku apps:create oo2-bitstarter-s-mooc --remote staging-heroku
heroku apps:create cs4e --remote production-heroku
#Es innecesario volver a crear las llaves de ssh, porque se ejecutó
#ya al crear la máquina virtual, con la opción adicional -C "email".
#ssh-keygen -t rsa
heroku keys:add
#Para versión con una sola rama:
#heroku addons:add heroku-postgresql:dev
#heroku pg:promote `heroku config  | grep HEROKU_POSTGRESQL | cut -f1 -d':'`
#heroku plugins:install git://github.com/ddollar/heroku-config.git
heroku addons:add heroku-postgresql:dev --app oo2-bitstarter-s-mooc
heroku addons:add heroku-postgresql:dev --app cs4e  
heroku pg:promote `heroku config --app oo2-bitstarter-s-mooc  | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app oo2-bitstarter-s-mooc
heroku pg:promote `heroku config --app cs4e  | grep HEROKU_POSTGRESQL | cut -f1 -d':'` --app cs4e
heroku plugins:install git://github.com/ddollar/heroku-config.git

# Set up heroku configuration variables
# https://devcenter.heroku.com/articles/config-vars
# - Edit .env to include your own COINBASE_API_KEY and HEROKU_POSTGRES_URL.
# - Modify the .env.dummy file, and DO NOT check .env into the git repository.
# - See .env.dummy for details.
#cp .env.dummy .env
# Lo anterior requiere una modificación manual, que mejor se realiza al
# clonear prueba-bitstarter-ssjs-db 
# Notar que .env no se registra, para no publicar el password de bitcoin,
# por estar en .gitignore

# For local: setup postgres (one-time) and then run the local server
# los datos del usuario de postgress estan en .pgpass
./pgsetup.sh

STRING=$( cat <<EOF
Great. You've now set up local and remote postgres databases for your
app to talk to.\n\n

Now do the following:\n\n

1) Get your API key from coinbase.com/account/integrations\n\n
2) Paste it into the .env file.\n\n
3) To run the server locally, do:\n
     $ foreman start\n
   Then check your EC2 URL, e.g. ec2-54-213-131-228.us-west-2.compute.amazonaws.com:8080 \n
   Try placing some orders and then clicking '/orders' at the top.\n\n
4) To deploy to heroku\n
4.1) Using only one branch\n
     $ git push heroku master\n
     $ heroku config:push\n
4.2) Using three branches\n
     $ heroku config:push --remote staging-heroku\n
     $ heroku config:push --remote production-heroku\n
     $ git push staging-heroku staging:master\n
     $ git push production-heroku master:master\n

5) Then check the corresponding Heroku URL\n\n
   Try placing some orders and then clicking '/orders' at the top.\n
EOF
)
echo -e $STRING
