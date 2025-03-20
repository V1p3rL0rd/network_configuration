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

## Configuration File Locations

### Ubuntu:
- Main configuration file: `/etc/netplan/01-netcfg.yaml`
- Backup file: `/etc/netplan/01-netcfg.yaml.backup`

### RHEL:
- Main configuration file: `/etc/sysconfig/network-scripts/ifcfg-[INTERFACE]`
- Backup file: `/etc/sysconfig/network-scripts/ifcfg-[INTERFACE].backup`
- DNS settings: `/etc/resolv.conf`

## Verifying Settings

After running the script, you can verify the settings using these commands:

```bash
ip addr show
ip route show
```

For DNS verification:
- Ubuntu: `systemd-resolve --status`
- RHEL: `cat /etc/resolv.conf`

## Restoring from Backup

In case of issues, you can restore previous settings from backup:

For Ubuntu:
```bash
sudo cp /etc/netplan/01-netcfg.yaml.backup /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

For RHEL:
```bash
sudo cp /etc/sysconfig/network-scripts/ifcfg-[INTERFACE].backup /etc/sysconfig/network-scripts/ifcfg-[INTERFACE]
sudo systemctl restart NetworkManager
```

## Security

- Scripts require root privileges
- Backups are created for all modified files
- Connection testing after applying settings

## Troubleshooting

If you encounter problems:
1. Verify the correctness of entered parameters
2. Ensure you have root privileges
3. Check system logs: `journalctl -xe`
4. Restore settings from backup if necessary

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Submit a pull request

## Authors

Initial Author - [Your Name]

## Support

For support, please create an issue in the GitHub repository or contact the maintainers. 
