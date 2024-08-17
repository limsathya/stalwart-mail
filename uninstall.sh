#!/bin/bash

# Function to stop and remove Docker container and image
uninstall_docker() {
    echo "Stopping and removing Stalwart Mail container..."
    sudo docker-compose down
    echo "Removing Stalwart Mail image..."
    sudo docker rmi stalwartlabs/mail
}

# Function to clean up Docker Compose files
cleanup_files() {
    echo "Removing Docker Compose files and data directory..."
    cd ~/stalwart-mail || exit
    sudo rm -rf data
    sudo rm -f docker-compose.yml
}

# Function to uninstall Docker and Docker Compose
uninstall_docker_packages() {
    echo "Uninstalling Docker and Docker Compose..."
    sudo apt remove -y docker.io docker-compose
    sudo apt autoremove -y
}

# Main execution
echo "Uninstalling Stalwart Mail..."
uninstall_docker
cleanup_files
uninstall_docker_packages

echo "Uninstallation complete!"
