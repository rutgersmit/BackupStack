#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "🧙‍  Please run me as root"
  exit
fi

DIR="/data/disk1"

echo -n "❓  Is the external drive mounted to $DIR? (y/n) "
read mounted

if [ "$mounted" != "${mounted#[Yy]}" ] ;then
    #echo "Ok, let's check"
    if [ ! -d $DIR ]; then
      # Take action if $DIR exists. #
      echo "❌  Could not find the mounted disk on $DIR, please check the mount and try again."
      exit
    fi
    echo "✔  Disk mounted to the right location, let's continue!"
else
    exit
fi

echo "🔍  Checking if docker is installed"
if ! command -v docker &> /dev/null
then
    echo "❌  docker could not be found, installing it"
    apt update

    if [  -n "$(uname -a | grep Ubuntu)" ]; then
      apt install docker.io -y
    else
      # wel... dunno, actually never been here
      apt install docker-ce -y
    fi
	echo "✔  docker succesfully installed"
else
    echo "✔  docker already installed"
fi

echo "🔍  Checking if docker compose is installed"
if ! command -v docker-compose &> /dev/null
then
    echo "❌  docker compose could not be found, installing it"
    apt update
    apt install docker-compose -y
	echo "✔  docker compose succesfully installed"
else
    echo "✔  docker compose already installed"
fi

# create some dirs for persistent storage for Docker containers
mkdir -p /var/docker/portainer
mkdir -p /var/docker/nextcloud
mkdir -p $DIR/mariadb
chown -R www-data /var/docker/nextcloud

# echo variables into .env file which is read by docker compose
PASSWORD=`date +%s | sha256sum | base64 | head -c 32`
echo "MYSQLPASSWORD=$PASSWORD" > .env
echo "DATAROOT=$DIR" >> .env

# bring up the container stack
echo "🚀️  Starting the docker stack"
docker-compose -p backupstack -f backupstack.yaml up -d

echo "🧘  Done, everything should be running"

ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
echo "🌍  Portainer runs on http://$ip:9000"
echo "🌍  Nextcloud runs on http://$ip:8017"
echo "🌍  Adminer runs on http://$ip:8092"
echo "🌍  Wireguard listens on port 51820"
