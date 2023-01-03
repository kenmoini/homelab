# Homelab Infrastructure

By Infrastructure I generally mean the pets that I maintain and the things I use to maintain them.

At large this is going to comprise of physical systems, but also a few key virtual machines that may run important things that I also name with cute space names.

## Physical Systems

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

## Kickstart Files

Every now and then I need to rebuild a system from the ground up - the hardware doesn't change often and neither does the network architecture they're connected to, so the intended state of the out-of-box installed systems should be able to be defined as a Kickstart file, with little if anything required between installing the system and configuring it with Ansible.

The Kickstart files namely do a few things:

- Automate the install of RHEL
- Configure the network interfaces, importantly the bridge interfaces that are then consumed by Libvirt and Podman
- Configure the storage root volume with a flat LVM layout
- Set the root password and add an SSH key that is then used to configure the system with Ansible

## Ansible Automation

Once the systems are installed and rebooted, they should be in a state that they can then be configured to adhere to a Standard Operating Environment.  Importantly the process can be done at scale across a large number of systems to set up a whole lab, and re-run to update the configuration of the systems in a safe idempotent way.  The key functions it provides are:

- Set the hostname
- Add additional trusted Root CA Certificates
- Subscribe the RHEL system
- Run additional roles to do things like:
  - Update the system
  - Install base packages
  - Configure the Cockpit Web UI
  - Configure NTP client configuration (chrony)
  - Configures SSHd
  - Attach NFS mounts
  - Join a FreeIPA/IDM domain/realm
  - Set it up as a common KVM host
  - Set it up as a common Podman host
  - Configures the system firewall