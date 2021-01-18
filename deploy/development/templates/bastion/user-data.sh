#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y postgresql
sudo yum install -y mysql
sudo usermod -aG docker ec2-user
