#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "🧙 Please run as root"
  exit
fi

DIR="/data/disk1"

echo -n "Is the external drive mounted to $DIR? (y/n)"
read mounted

if [ "$mounted" != "${mounted#[Yy]}" ] ;then
    #echo "Ok, let's check"
    if [ ! -d $DIR ]; then
      # Take action if $DIR exists. #
      echo "Could not find the mounted disk on $DIR"
      echo "Please check the mount and try again."
      exit
    fi
    echo "Disk mounted to the right location, let's continue!"
else
    exit
fi



#exit
apt update
apt install docker.io -y
apt install docker-compose -y

# create some dirs for persistent storage for Docker containers
mkdir -p /var/docker/nextcloud
mkdir -p $DIR/mariadb
chown -R www-data /var/docker/nextcloud


echo "Checking if Portainer is installed"
if [ ! "$(docker ps -q -f name=portainer)" ]; then
  echo "Portainer is not installed, installing it right now. Why? Because I'm lazy"
  mkdir -p /var/docker/portainer
  # install portainer because...
  docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/docker/portainer:/data portainer/portainer-ce
fi
exit

# echo variables into /env file which is read by docker compose
echo PASSWORD = `date +%s | sha256sum | base64 | head -c 32`
echo "MYSQLPASSWORD=$PASSWORD" > .env
echo "DATAROOT=$DIR" >> .env

# bring up the container stack
docker-compose -p backupstack -f backupstack.yaml up --detach

echo "Done, everything should be running 🚀"