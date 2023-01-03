configure-firewall
=========

This role configures Linux system firewalls - currently supports firewalld, but the bits are there to easily add in the ufw support whenever I get around to it.

Requirements
------------

This role needs python-firewall or python3-firewall on managed nodes. It is usually provided as a subset with firewalld from the OS distributor for the OS default Python interpreter.

Role Variables
--------------

```yaml
#==============================================================================
# defaults for the role

# reboot_after_default_zone_change is whether or not to reboot the system after changing the default zone, helps for changes affecting active interfaces
reboot_after_default_zone_change: false

# reboot_wait_timeout is the number of seconds to wait for the node to come back online after rebooting
reboot_wait_timeout: 3600

#==============================================================================
# OS specific variables, example for RHEL

firewall_packages:
- firewalld
- python3-firewall

#==============================================================================
# Input variables for the role

```

Dependencies
------------

This role depends on the [ansible.posix](https://galaxy.ansible.com/ansible/posix) and [community.general](https://galaxy.ansible.com/community/general) Ansible Collections, and are included in the `collections/requirements.yml` file.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).

Extra Information
-----------------

- https://firewalld.org/documentation/man-pages/firewalld.zone.html