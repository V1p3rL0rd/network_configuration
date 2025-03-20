#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this script as root"
    exit 1
fi

# Determine primary network interface
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)

# Get current connection name
CONNECTION_NAME=$(nmcli -g NAME connection show --active | grep -v 'lo' | head -n1)

if [ -z "$CONNECTION_NAME" ]; then
    CONNECTION_NAME="static-$INTERFACE"
fi

# Request network parameters
read -p "Enter host IP address (e.g., 192.168.1.100): " IP_ADDRESS
read -p "Enter subnet mask in CIDR format (e.g., 24 for /24): " NETMASK
read -p "Enter gateway address (e.g., 192.168.1.1): " GATEWAY
read -p "Enter primary DNS server: " DNS1
read -p "Enter secondary DNS server: " DNS2

echo "Creating backup of current settings..."
nmcli connection show "$CONNECTION_NAME" > "/tmp/network_backup_$(date +%Y%m%d_%H%M%S).txt"

echo "Configuring new connection..."
# Remove old connection if it exists
nmcli connection down "$CONNECTION_NAME" 2>/dev/null
nmcli connection delete "$CONNECTION_NAME" 2>/dev/null

# Create new connection
nmcli connection add \
    type ethernet \
    con-name "$CONNECTION_NAME" \
    ifname "$INTERFACE" \
    ipv4.method manual \
    ipv4.addresses "$IP_ADDRESS/$NETMASK" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS1,$DNS2" \
    ipv4.never-default no \
    connection.autoconnect yes

# Activate connection
echo "Activating new connection..."
nmcli connection up "$CONNECTION_NAME"

# Verify settings
echo -e "\nNew network settings:"
echo "========================="
echo "Interface: $INTERFACE"
echo "Connection: $CONNECTION_NAME"
echo "IP Address: $IP_ADDRESS/$NETMASK"
echo "Gateway: $GATEWAY"
echo "DNS Servers: $DNS1, $DNS2"
echo "========================="

# Test connection
echo -e "\nTesting connection..."
ping -c 3 $GATEWAY

if [ $? -eq 0 ]; then
    echo "Network configuration completed successfully!"
else
    echo "Warning: Unable to ping gateway. Please check your settings."
fi

echo -e "\nTo verify settings, run:"
echo "nmcli connection show $CONNECTION_NAME"
echo "ip addr show $INTERFACE"
echo "ip route show"
echo "nmcli device show $INTERFACE | grep IP4"

echo -e "\nTo restore previous settings, use the backup file in /tmp/network_backup_*.txt" 
