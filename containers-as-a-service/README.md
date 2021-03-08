# Containers-as-a-Service

No, this is not like an ECS sort of offering - Containers-as-a-Service in this scope means running Containers as a SystemD Service via Podman.

In the scope of this repository collection, these CaaS resources are stored in the `/opt/service-containers` directory.

## Defined Container Services

- DNS Core
- PiHole Ad Blocker DNS Servers

### DNS Core Services via GoZones

GoZones takes DNS Zones defined as YAML and converts it into BIND compliant configuration and zone files.  There's a container that will process the conversion and then launch a BIND daemon all-in-one.

There are two CaaS deployments defined `dns-core-1` and `dns-core-2` to provide two DNS Servers at the IP addresses `192.168.42.{9,10}`

### DNS Ad Blocking with PiHole

PiHole provides an easy DNS-based network ad-blocker and a great dashboard.  In my lab it's used as the final upstream DNS servers and then forwards to Cloudflare's DNS.

There are two CaaS deployments defined as `dns-pihole-1` and `dns-pihole-2` to provide Ad blocking DNS servers at the IP addresses `192.168.42.{11,12}`

## Initial Setup

### Linux Bridge Network Device

First you must create a Bridge Network Device on your system - this creates a virtual device, the bridge, that allows containers and VMs on your system to connect through to the network that system is connected to.

Creating a Bridge device is outside of the scope of this document, find the different ways to create one here: https://www.tecmint.com/create-network-bridge-in-rhel-centos-8/

### Podman Bridge Network

By default, containers will have access to a bridge device that connects the Pods to a NAT'd network.  This is not ideal for running static services for your network - instead, use Podman to create a new network that uses a macvlan-style container network to connect to a bridge device.  Run the following commands:

```bash
sudo podman create network lanBridge
sudo nano /etc/cni/net.d/lanBridge.conflist
```

Make the file look something like this, substituting for ***bridge*** (your bridge device), and your bridged network subnet and ***range*** Podman can utilize (it can overlap with your full subnet, DHCP would be passed off to the gateway through the bridge):

```json
{
   "cniVersion": "0.4.0",
   "name": "lanBridge",
   "plugins": [
      {
         "type": "bridge",
         "bridge": "LANbr0",
         "ipam": {
            "type": "host-local",
            "ranges": [
                [
                    {
                        "subnet": "192.168.42.0/24",
                        "rangeStart": "192.168.42.2",
                        "rangeEnd": "192.168.42.254",
                        "gateway": "192.168.42.1"
                    }
                ]
            ],
            "routes": [
                {"dst": "0.0.0.0/0"}
            ]
         }
      },
      {
         "type": "portmap",
         "capabilities": {
            "portMappings": true
         }
      },
      {
         "type": "firewall",
         "backend": ""
      },
      {
         "type": "tuning",
         "capabilities": {
            "mac": true
         }
      }
   ]
}
```

## Lifecycle

Naturally there are a series of steps to take to deploy any of these CaaS items.  That's why in the root of this repository in the `ansible-collections/playbooks` directory you can find a number of Playbooks prefixed with `deploy-caas-` to make quick work of deploying these services.