update-system
=========

Updates a Linux server, optionally rebooting after a kernel update.

Requirements
------------

None.

Role Variables
--------------

```yaml
#==============================================================================
# default variables for the role

# reboot_after_kernel_update enables rebooting after a kernel update, default is false
reboot_after_kernel_update: false
```

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: update-system, reboot_after_kernel_update: true }

- name: Other play with other servers to configure
  hosts: other_servers
  tasks:
    - name: Include the role
      include_role:
        name: update-system
        tasks_from: main
      vars:
        reboot_after_kernel_update: true
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).