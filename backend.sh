#!/bin/bash

# Update and install Docker
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker

# Check if Docker network exists, if not create it
if ! sudo docker network ls | grep -q backend-network; then
    sudo docker network create backend-network
fi

# Remove existing backend-db container if it exists
if sudo docker ps -a --format '{{.Names}}' | grep -q backend-db; then
    sudo docker rm -f backend-db || echo "Failed to remove existing backend-db container"
fi

# Run MySQL container
sudo docker run -d --name backend-db \
    --network backend-network \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    mysql:latest

# Remove existing backend-app container if it exists
if sudo docker ps -a --format '{{.Names}}' | grep -q backend-app; then
    sudo docker rm -f backend-app || echo "Failed to remove existing backend-app container"
fi

# Run Backend application container
sudo docker run -d -p 5000:5000 --name backend-app \
    --network backend-network \
    -e MYSQL_HOST=backend-db \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    kubeashukube/backend:latest
