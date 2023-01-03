# Networks

> Subnets, VLANs, and where to find them
> 
> Not inclusive of current SD-WAN

Too simple of a network and you get no control of your network.  Too complex of a network and you spend all your time trying to control it.

This lab is segmented into a set of networks. Each network is a separate subnet, and each subnet is a separate VLAN that usually corresponds to the 3rd octet of the IPv4 block it aligns to. The following table shows the network and VLAN information:

| Network         | VLAN | DHCP Range         | Description            |
|-----------------|------|--------------------|------------------------|
| 192.168.42.0/24 |    0 | 192.168.42.2-250   | Default DHCP network   |
| 192.168.44.0/24 |   44 | 192.168.44.2-250   | Wireless network       |
| 192.168.46.0/24 |   46 | 192.168.46.2-250   | OOBM network           |
| 192.168.70.0/23 |   70 | 192.168.71.2-250   | Disconnected network   |

