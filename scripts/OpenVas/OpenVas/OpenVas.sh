#!/bin/sh
IP=$(hostname -I | awk '{ print $1 }')
DIR=$HOME/greenbone-community-container
#docker stop $(docker ps -q)
#sh setup-and-start-greenbone-community-edition.sh
#echo $IP

echo $DIR

docker-compose -f $DIR/docker-compose-22.4.yml -p $DIR/greenbone-community-edition pull

docker-compose -f $DIR/docker-compose-22.4.yml -p $DIR/greenbone-community-edition pull notus-data vulnerability-tests scap-data dfn-cert-data cert-bund-data report-formats data-objects

docker-compose -f $DIR/docker-compose-22.4.yml -p $DIR/greenbone-community-edition up -d

docker-compose -f $DIR/docker-compose-22.4.yml -p $DIR/greenbone-community-edition \
    exec -u gvmd gvmd gvmd --user=admin --new-password='Admin@123'

#$DIR/docker-compose -f docker-compose-22.4.yml -p greenbone-community-edition down -v

xdg-open 'http://'$IP':9392/login' &

#DISPLAY:0 chromium-browser --app='http://'$IP':9392/login' --kiosk &

