# Network configuration
Simple bash scripts to quickly configure network settings on RHEL and UBUNTU systems
To run the script, you need to follow next simple steps:

1. Download this script to your host
2. Give permissions to execute using chmod +x netconfig-rhel.sh
3. Run the script and enter your network settings as in the example below:

RHEL
$ sudo ./netconfig-rhel.sh

Enter the interface name (e.g., eth0): eth0

Enter the IP address (e.g., 192.168.1.100): 192.168.1.100

Enter the subnet mask (e.g., 24 or 255.255.255.0): 24

Enter the gateway (e.g., 192.168.1.1): 192.168.1.1

Enter DNS1 (e.g., 8.8.8.8): 8.8.8.8

Enter DNS2 (e.g., 8.8.4.4): 8.8.4.4

Configuring network for RHEL...

Network configuration completed successfully!

UBUNTU
$ sudo ./netconfig-ubuntu.sh

Enter the interface name (e.g., enp0s3): enp0s3

Enter the IP address (e.g., 192.168.1.100): 192.168.1.100

Enter the subnet mask (e.g., 24 or 255.255.255.0): 255.255.255.0

Enter the gateway (e.g., 192.168.1.1): 192.168.1.1

Enter DNS1 (e.g., 8.8.8.8): 8.8.8.8

Enter DNS2 (e.g., 8.8.4.4): 8.8.4.4

Configuring network for Ubuntu...

Network configuration completed successfully!
