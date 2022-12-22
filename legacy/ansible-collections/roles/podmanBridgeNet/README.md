podmanBridgeNet
=========

This role will create a macvlan-type container bridge network for Podman.

Requirements
------------

- Podman Installed

Role Variables
--------------

```yaml
---
# defaults file for podmanBridgeNet
# the logical name of your container bridge
bridgeName: lanBridge

# the physical device name of your bridge
bridgeDevice: containerLANbr0

# the bridged network details can overlap with full subnet, DHCP is passed to the gateway
bridgeSubnet: 192.168.42.0/24
bridgeGateway: 192.168.42.1
bridgeRangeStart: 192.168.42.2
bridgeRangeEnd: 192.168.42.245
```

Dependencies
------------

N/A

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - name: podmanBridgeNet
          vars:
            bridgeName: PodmanBridge
            bridgeDevice: br0

License
-------

MIT

Author Information
------------------

Set up by Ken Moini - it's only a few lines of YAML, anyone could do this.