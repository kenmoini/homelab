# Homelab Infrastructure Ansible Automation

> This document serves as the entrypoint to the Ansible automation that is used to configure my homelab infrastructure and set a Standard Operating Environment.

## Hardware

### The Raza

- **Name Influence**: [Dark Matter](https://darkmatter.fandom.com/wiki/Raza)
- **Hostname**: `raza.kemo.labs`
- **Build**: Custom Watercooled Tower
- **Operating System**: RHEL 8.6
- **Purpose**: Core Infrastructure Services (DNS, VPN, etc)

### Endurance

- **Name Influence**: [Interstellar](https://interstellarfilm.fandom.com/wiki/Endurance)
- **Hostname**: `endurance.kemo.labs`
- **Build**: Custom Watercooled Tower
- **Operating System**: RHEL 9.1
- **Purpose**: Bulk Infrastructure Services (KVM/Podman)

## Configuration Options

### Ansible Roles

If the below roles are linked directly to the role source in this repo then the documentation has been created - if not then that part is still a WIP (Work In Progress).

- [RHEL/Debian] **[add-root-ca-certs](roles/add-root-ca-certs/)** - Adds custom root CA certificates to the system
- [RHEL/Debian] **[update-system](roles/update-system/)** - Updates the system to the latest packages, optionally rebooting after a kernel update
- [RHEL/Debian] **[install-base-packages](roles/install-base-packages/)** - Installs base packages for the system
- [RHEL/Debian] **[configure-cockpit](roles/configure-cockpit/)** - Configures Cockpit on the system
- [RHEL/Debian] **[configure-nfs-mounts](roles/configure-nfs-mounts/)** - Configures NFS mounts on the system
- [RHEL/Debian] **[configure-ntp](roles/configure-ntp/)** - Configures the system to use NTP as a client
- [RHEL/Debian] **[kvm-host](roles/kvm-host/)** - Configures the system as a Libvirt/KVM host
- [RHEL/Debian] **[podman-host](roles/podman-host/)** - Configures the system as a Podman host
- [RHEL/Debian] **[setup-ipa-client](roles/setup-ipa-client/)** - Setup the system to join a FreeIPA/IDM domain/realm
- [WIP] configure-firewalld
- [WIP] configure-sshd

## Getting Started

### Prerequisites

```bash
## Install the pip modules
python3 -m pip install -r requirements.txt

## Install the Ansible collections
ansible-galaxy collection install -r requirements.yml
```

### Adding the Host to the Inventory

Add your host to your inventory however you need, but pay attention to the inventory_hostname you use - this is the directory name used to load the site config for the host.

### Creating a Site Config

A Site Config is basically just a collection of YAML variables that define the intended configuration state of a host.

There is a set of example site configs in the [site-configs/server.example.com](site-configs/server.example.com) directory that can be used as a starting point.

You can copy that directory to another one in the same `site-configs` directory, making sure the name of the directory matches the inventory_hostname of the host you want to configure - eg if you have a host in your inventory defined as `my-server.example.com` you would run `cp -R server.example.com my-server.example.com` and then edit the files located in the `my-server.example.com` directory to match the desired configuration state.

The organization of the files in the host's site config directory can be anything, just as long as the `yml` or `yaml` extension is used all of them will be loaded.
