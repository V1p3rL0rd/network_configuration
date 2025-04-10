#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Prompt user for input
read -p "Enter the interface name (e.g., eth0): " INTERFACE
read -p "Enter the IP address (e.g., 192.168.1.100): " IP
read -p "Enter the subnet mask (e.g., 24 or 255.255.255.0): " MASK
read -p "Enter the gateway (e.g., 192.168.1.1): " GATEWAY
read -p "Enter DNS1 (e.g., 8.8.8.8): " DNS1
read -p "Enter DNS2 (e.g., 8.8.4.4): " DNS2

# Check if the interface exists
if ! ip link show dev "$INTERFACE" &> /dev/null; then
    echo "Error: Interface $INTERFACE does not exist"
    exit 1
fi

# Function to convert subnet mask to prefix
mask_to_prefix() {
    local mask=$1
    if [[ $mask =~ ^[0-9]{1,2}$ ]]; then
        echo "$mask"
        return
    fi

    local prefix=0
    local octets=( ${mask//./ } )
    for octet in "${octets[@]}"; do
        case $octet in
            255) ((prefix += 8)) ;;
            254) ((prefix += 7)) ;;
            252) ((prefix += 6)) ;;
            248) ((prefix += 5)) ;;
            240) ((prefix += 4)) ;;
            224) ((prefix += 3)) ;;
            192) ((prefix += 2)) ;;
            128) ((prefix += 1)) ;;
            0)   ;;
            *)    echo "Error: Invalid subnet mask $mask" >&2; exit 1 ;;
        esac
    done
    echo "$prefix"
}

PREFIX=$(mask_to_prefix "$MASK") || exit 1

# Configure network using nmcli
echo "Configuring network for RHEL/CentOS..."

# Check if the connection already exists
if ! nmcli con show "$INTERFACE" &> /dev/null; then
    echo "Creating a new connection for $INTERFACE"
    nmcli con add type ethernet con-name "$INTERFACE" ifname "$INTERFACE"
fi

# Apply network settings
nmcli con mod "$INTERFACE" \
    ipv4.method manual \
    ipv4.addresses "$IP/$PREFIX" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS1 $DNS2"

# Restart the connection
nmcli con down "$INTERFACE" && nmcli con up "$INTERFACE"

echo "Network configuration completed successfully!"
