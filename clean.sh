#!/bin/bash
if [ $EUID -ne 0 ]; then
  echo "🧙‍  Please run me as root"
  exit
fi

echo "🧹  cleaning..."

docker-compose -f backupstack.yaml down

rm -rf /data/docker/*
rm -rf /data/disk1/*

echo "🤷  done, everything is gone"
