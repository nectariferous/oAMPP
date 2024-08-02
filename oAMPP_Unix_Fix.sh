#!/bin/bash

# oAMPP - XAMPP Configuration Helper for Unix-like systems
# Author: VorTexCyberBD
# License: MIT

# Function to display animated text
show_animated_text() {
    text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo
}

# Function to show progress bar
show_progress() {
    percentage=$1
    bar=$(printf '=%.0s' $(seq 1 $((percentage/2))))
    spaces=$(printf ' %.0s' $(seq 1 $((50-percentage/2))))
    printf "\r[%s%s] %d%%" "$bar" "$spaces" "$percentage"
}

# Main script
clear
show_animated_text "Welcome to oAMPP - XAMPP Configuration Helper for Unix-like systems!"
show_animated_text "Developed by Apache Friends, enhanced by VorTexCyberBD"

# Check if XAMPP is installed
if [ -d "/opt/lampp" ]; then
    show_animated_text "XAMPP installation found. Optimizing configuration..."
    
    # Backup original configuration
    sudo cp /opt/lampp/etc/httpd.conf /opt/lampp/etc/httpd.conf.backup
    
    # Modify Apache configuration
    sudo sed -i 's/^Listen 80/Listen 8080/' /opt/lampp/etc/httpd.conf
    sudo sed -i 's/^User daemon/User '$(whoami)'/' /opt/lampp/etc/httpd.conf
    sudo sed -i 's/^Group daemon/Group '$(id -gn)'/' /opt/lampp/etc/httpd.conf
    
    show_animated_text "Apache configuration updated. XAMPP will now run on port 8080."
else
    show_animated_text "XAMPP installation not found. Please install XAMPP first."
fi

# Download latest XAMPP installer
show_animated_text "Downloading latest XAMPP installer..."
wget -O xampp-installer.run "https://www.apachefriends.org/xampp-files/8.2.4/xampp-linux-x64-8.2.4-0-installer.run"
chmod +x xampp-installer.run

show_animated_text "XAMPP installer downloaded. Run ./xampp-installer.run to install."

show_animated_text "Opening Telegram channel..."
xdg-open "https://t.me/VorTexCyberBD"

show_animated_text "Configuration complete! Thank you for using oAMPP!"
read -p "Press Enter to exit"
