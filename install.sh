#!/bin/bash
if [ $EUID -ne 0 ]; then
  echo "🧙‍  Please run me as root"
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
    echo "✅  Disk mounted to the right location, let's continue!"
else
    exit
fi

echo "🔍  Checking if docker is installed"
if ! command -v docker &> /dev/null
then
    echo "❌  docker could not be found, installing it"
    apt update

    if [ -n "$(uname -a | grep Ubuntu)" ]; then
      apt install docker.io -y
    else
      # wel... dunno, actually never been here
      apt install docker-ce -y
    fi
	echo "✅  docker succesfully installed"
else
    echo "✅  docker already installed"
fi

echo "🔍  Checking if docker compose is installed"
if ! command -v docker-compose &> /dev/null
then
    echo "❌  docker compose could not be found, installing it"
    apt update
    apt install docker-compose -y
	echo "✅  docker compose succesfully installed"
else
    echo "✅  docker compose already installed"
fi


# create some dirs for persistent storage for Docker containers
echo "📂  Doing some filesystem stuff"
mkdir -p /data/docker/portainer
mkdir -p /data/docker/filebrowser
mkdir -p $DIR/data

# add sftp user
echo "🤓  Adding SFTP user"
useradd sftpuser
passwd sftpuser
usermod -d $DIR/data sftpuser


# echo variables into .env file which is read by docker compose
PASSWORD=`date +%s | sha256sum | base64 | head -c 32`
echo "MYSQLPASSWORD=$PASSWORD" > .env
echo "DATAROOT=$DIR" >> .env


# bring up the container stack
echo "🚀️  Starting the docker stack"
docker-compose -p backupstack -f backupstack.yaml up -d

chown -R sftpuser $DIR/data

echo "🧘  Done, everything should be running"+

IP="$(hostname -I | cut -d " " -f 1)"
echo "🌍  Portainer runs on http://$IP:9000"
echo "🌍  Filebrowser runs on http://$IP:8017"
echo "🌍  Wireguard listens on port 51820"