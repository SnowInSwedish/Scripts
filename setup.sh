#!/bin/bash

# Define the container name
container_name="github"

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed. Please install Docker before running this script."
    exit 1
fi

# Check if the container already exists and remove it if it does
if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}\$"; then
    echo "Removing existing container: $container_name"
    docker stop $container_name
    docker rm $container_name
fi

# Create a new container and pull the GitHub repository
echo "Creating and setting up container: $container_name"
docker run -d --name $container_name -p 80:80 ubuntu:latest tail -f /dev/null

# Install necessary packages inside the container
docker exec -it $container_name apt-get update
docker exec -it $container_name apt-get install -y git apache2

# Install PHP support
docker exec -it $container_name apt-get install -y php libapache2-mod-php

# Install Python support
docker exec -it $container_name apt-get install -y python3

# Install Node.js support
docker exec -it $container_name apt-get install -y nodejs npm

# Install Ruby support
docker exec -it $container_name apt-get install -y ruby

# Install Java and Tomcat
docker exec -it $container_name apt-get install -y openjdk-11-jdk
docker exec -it $container_name apt-get install -y tomcat9

# Remove the existing html directory
docker exec -it $container_name rm -rf /var/www/html

# Clone the GitHub repository contents into the html directory
docker exec -it $container_name git clone https://github.com/SnowInSwedish/Hemsida.git /var/www/html

# Start the Apache web server inside the container
docker exec -it $container_name service apache2 start

echo "Container setup complete. Access your website at http://localhost"
