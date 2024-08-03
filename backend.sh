#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo docker network create backend-network
sudo docker run -d --name backend-db --network backend-network -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=mydb mysql:latest
sudo docker run -d -p 5000:5000 --name backend-app --network backend-network -e MYSQL_HOST=backend-db your-dockerhub-username/backend:latest

