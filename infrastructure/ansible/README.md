# Homelab Infrastructure Ansible Automation

> This document serves as the entrypoint to the Ansible automation that is used to configure my homelab infrastructure.

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
- [RHEL] **[kvm-host](roles/kvm-host/)** - Configures the system as a Libvirt/KVM host
- [RHEL] **[podman-host](roles/podman-host/)** - Configures the system as a Podman host
- [WIP] configure-firewalld
- [WIP] configure-sshd
- [WIP] setup-ipa-client

## Getting Started

### Prerequisites

```bash
## Install the pip modules
python3 -m pip install -r requirements.txt

## Install the Ansible collections
ansible-galaxy collection install -r requirements.yml
```