# netOps - Ansible Network Operstion Tasks

## BACKUP
This is an ansible role, which creates a config file of each network device
So far, we do care about:
* Huawei Cloud Engine Devices
* Cisco Catalyst Switches
* Cisco ASA Firewalls
* Cisco WLAN Controller
* Fortigate Firewalls

### backup_all_devices.yml
Simple example to backup all network devices into one dir with single config for each device

### push_device_configs_to_git.sh
Shell script to create branch for each device and push it to git repo.    
This makes it easy to search changes.


## NET_EXEC
Run cli commands on several device types and evaluate return code depending on device type
(this is coming soon)

## License
GNU GENERAL PUBLIC LICENSE - Version 3


## Author Information
I do Linux and Ansible for ages, and you can hire my services if you have interesting projects.

