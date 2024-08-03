#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo docker run -d -p 80:80 kubeashukube/frontend:latest

