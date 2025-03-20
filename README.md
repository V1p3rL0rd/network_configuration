# Network Configuration Scripts for Ubuntu and RHEL

These scripts are designed to automate the network configuration process on Ubuntu and RHEL servers. They allow you to quickly set up static IP addresses, subnet masks, gateways, and DNS servers.

## Features

- Automatic detection of the primary network interface
- Interactive input of network parameters
- Creation of configuration file backups
- Connection testing after setup
- Detailed output of new settings

## Requirements

### For Ubuntu:
- Ubuntu 24.04 or newer
- Root privileges
- Netplan installed

### For RHEL:
- RHEL 9.5 or newer
- Root privileges
- NetworkManager

## Usage

1. Make the scripts executable:
```bash
chmod +x netconfig-ubuntu.sh
chmod +x netconfig-rhel.sh
```

2. Run the appropriate script:

For Ubuntu:
```bash
sudo ./netconfig-ubuntu.sh
```

For RHEL:
```bash
sudo ./netconfig-rhel.sh
```

3. Follow the prompts and enter the requested parameters:
- Host IP address
- Subnet mask (in CIDR format)
- Gateway address
- Primary DNS server
- Secondary DNS server


## Security

- Scripts require root privileges
- Backups are created for all modified files
- Connection testing after applying settings

## Troubleshooting

If you encounter problems:
1. Verify the correctness of entered parameters
2. Ensure you have root privileges
3. Check system logs: `journalctl -xe`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
