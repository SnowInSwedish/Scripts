# Docker Setup Script for Mac

This script sets up a Docker container named "github" with a complete web development environment, including Apache, PHP, Python, Node.js, Ruby, and Java. It then clones a GitHub repository into the container's web server directory and starts the Apache web server.

## Prerequisites

- Docker installed on your Mac
- Internet connection to download necessary packages and clone the GitHub repository

## Script Overview

The script performs the following steps:

1. Checks if Docker is installed.
2. Removes any existing container named "github".
3. Creates a new Ubuntu-based container.
4. Installs Apache, PHP, Python, Node.js, Ruby, and Java inside the container.
5. Clones the specified GitHub repository into the web server's document root.
6. Starts the Apache web server.

## How to Use

1. **Download the Script:**

   Save the following script as `setup_github_container.sh`:

   ```bash
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
   ```

2. **Make the Script Executable:**

   ```sh
   chmod +x setup_github_container.sh
   ```

3. **Run the Script:**

   ```sh
   ./setup_github_container.sh
   ```

## Notes

- The script will overwrite any existing container named "github".
- Ensure the necessary ports (80) are not being used by other services on your Mac.
- The script installs multiple development tools and may take some time to complete.

## License

This project is licensed under the MIT License.

---
