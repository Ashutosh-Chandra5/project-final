#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker

# Create Docker network
sudo docker network create backend-network

# Run MySQL container
sudo docker run -d --name backend-db \
    --network backend-network \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    mysql:latest

# Run Backend application container
sudo docker run -d -p 5000:5000 --name backend-app \
    --network backend-network \
    -e MYSQL_HOST=backend-db \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    kubeashukube/backend:latest

