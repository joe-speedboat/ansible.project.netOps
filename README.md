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
Copyright (c) Chris Ruettimann <chris@bitbull.ch>    
I don't do Linux for 20 years because I love Unix or consoles.   
OpenSource is what I love and want to do ...    
moving together ...     
that fascinates me ...    
whether in a team, in a project, in a product or in a relationship ....     
I think this is a philosophy that is worth it.
