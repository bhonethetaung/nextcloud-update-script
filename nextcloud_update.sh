#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" &> /dev/null
}

# Check if unzip command is available
if ! command_exists unzip; then
    echo "Error: 'unzip' command not found. Do you want to install it? (y/n)"
    read -r install_unzip

    if [ "$install_unzip" == "y" ]; then
        # Install unzip (assuming a Debian-based system, adjust for other systems)
        sudo apt-get update
        sudo apt-get install unzip
    else
        echo "Aborted. 'unzip' is required for the script."
        exit 1
    fi
fi

# Get download link from user
read -p "Enter the download link: " file_url

# Download the file
curl -LOJ "$file_url"

# Extract the contents using unzip
unzip -q *.zip

# Optionally, remove the downloaded zip file
rm *.zip

echo "For eg. version 7.10.2 as 7102"
read -p "Enter the name for backup file: " name
mv /var/www/nextcloud /var/www/ver/nextcloud-$name
mv nextcloud/ /var/www
cp -r /var/www/ver/config /var/www/nextcloud
cp -r /var/www/ver/data /var/www/nextcloud

cd /var/www/
chown -R www-data:www-data nextcloud
systemctl restart nginx
cd nextcloud/
sudo -u www-data php occ upgrade
systemctl restart nginx
cd
echo "Done! Nextcloud is Updated version now"
