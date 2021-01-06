#! /bin/bash

if [ "$EUID" -ne 0 ]

  then echo "🧙  please run me as root"
  exit

else
  echo "🧹  cleaning..."

  docker-compose -f backupstack.yaml down
  rm -rf /data/docker/*
  rm -rf /data/disk1/*

  sudo pkill -u sftpuser
  deluser sftpuser

  echo "🤷  done, everything is gone"

fi