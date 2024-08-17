#!/bin/bash

# Function to check if a package is installed
check_install() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installing $1..."
        sudo apt install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Function to install Docker if not installed
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        sudo apt update
        sudo apt install -y docker.io
    else
        echo "Docker is already installed."
    fi
}

# Function to install Docker Compose if not installed
install_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose not found. Installing Docker Compose..."
        sudo apt install -y docker-compose
    else
        echo "Docker Compose is already installed."
    fi
}

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
check_install "curl"
check_install "nano"

# Install Docker and Docker Compose
install_docker
install_docker_compose

# Prompt user for domain and admin credentials
read -p "Enter your domain (e.g., example.com): " DOMAIN
read -p "Enter your admin email (e.g., admin@$DOMAIN): " ADMIN_EMAIL
read -s -p "Enter your admin password: " ADMIN_PASSWORD
echo

# Create a directory for Stalwart Mail
mkdir -p ~/stalwart-mail && cd ~/stalwart-mail

# Create Docker Compose configuration
cat <<EOL > docker-compose.yml
version: '3'

services:
  mailserver:
    image: stalwartlabs/mail
    container_name: stalwart-mail
    environment:
      - STALWART_DOMAIN=$DOMAIN
      - STALWART_ADMIN_EMAIL=$ADMIN_EMAIL
      - STALWART_ADMIN_PASSWORD=$ADMIN_PASSWORD
    ports:
      - "25:25"
      - "143:143"
      - "587:587"
      - "993:993"
    volumes:
      - ./data:/var/lib/stalwart-mail
    restart: always
EOL

# Start the mail server
sudo docker-compose up -d

# Provide DNS setup instructions
echo "Installation complete!"
echo "Please set the following DNS records for your domain:"
echo "1. MX Record: Name: @, Value: mail.$DOMAIN, Priority: 10"
echo "2. SPF Record: Name: @, Value: v=spf1 mx -all"
echo "3. Optionally set up DKIM and DMARC for better email deliverability."
