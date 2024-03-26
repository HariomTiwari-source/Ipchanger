#!/bin/sh

# Define IP_CHANGER function
IP_CHANGER() {
    echo -e "\e[32m"
    sudo figlet "IP CHANGER"  # Fixed figlet command
    echo -e "\e[0m"
    read -p "Do you want to enter the IP manually or automatically? (M/A): " input
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase
             
    if [ "$input" = "m" ]; then
        read -p "Enter the interface you want to configure: " interface
        read -p "Enter the IP: " IP
        
        # Validate IP address format
        if ! echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
            echo "Invalid IP address format!"
            exit 1
        fi
        
        sudo ifconfig "$interface" "$IP"
        ifconfig | grep "$IP"
        echo ""
        assigned_ip=$(ifconfig "$interface" | awk '/inet / {print $2}')
        if [ "$assigned_ip" = "$IP" ]; then
            echo "IP changed successfully"
        else
            echo "Failed to change IP"
        fi
    elif [ "$input" = "a" ]; then
        ip="192.168.55.72"  # Fixed the assignment statement
        sudo ifconfig eth0 "$ip"  # Fixed the ifconfig command
        assigned_ip=$(ifconfig eth0 | awk '/inet / {print $2}' | cut -d ':' -f2)  # Correctly extract IP address
        if [ "$assigned_ip" = "$ip" ]; then
            echo "IP changed successfully"
        else
            echo "Failed to change IP"
         fi 
    else
        echo "Invalid input !!"  
    fi
}

# Checking root permission
if [ "$(id -u)" -eq 0 ]; then
    IP_CHANGER
else
    echo "User does not have root permission"
fi

