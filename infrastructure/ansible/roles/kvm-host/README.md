kvm-host
=========

Configures a host to be a KVM/libvirt host.  Will also create a Libvirt bridge network for any bridge network it detects on the host.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

```yaml
#==============================================================================
# defaults for kvm-host

# enable_nested_virt enables nested virtualization, default is true
enable_nested_virt: true

# enable_unsafe_interrupts enables unsafe interrupts, default is true
enable_unsafe_interrupts: true

# libvirt_packages is a list of packages to install for libvirt, and maybe some extras
libvirt_packages:
- virt-install
- virt-viewer
- virt-top
- cockpit-machines
- libvirt
- libguestfs-tools
```

Dependencies
------------

None.

Example Playbook
----------------

```yaml

- hosts: servers
  roles:
      - { role: kvm-host, enable_nested_virt: false }

- name: Other play with other servers to configure
  hosts: other_servers
  tasks:
  - name: Include the role
    include_role:
      name: kvm-host
    vars:
      enable_nested_virt: false
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).