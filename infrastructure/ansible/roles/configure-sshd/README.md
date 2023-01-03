configure-sshd
=========

Configures SSHd to general standards or something I guess.

Requirements
------------

None

Role Variables
--------------

```yaml
#==============================================================================
# defaults for the role

# sshd_port is the port the SSHd service will listen on.
# If not the standard port 22 then the SELinux context is added to the port.
sshd_port: 22

# sshd_address_family is the address family the SSHd service will listen on.
sshd_address_family: any

# sshd_listen_addresses is the list of addresses the SSHd service will listen on.
sshd_listen_addresses:
- 0.0.0.0
- ::

```

Dependencies
------------

This role depends on the [community.general](https://docs.ansible.com/ansible/latest/collections/community/general/index.html) collection, part of the collections/requirements.yml file.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: configure-sshd, sshd_port: 2222 }

- name: Other play with other hosts including the role in another way
  hosts: otherServers
  tasks:
  - name: Include the role this way
    include_role:
      name: configure-sshd
    vars:
      sshd_port: 2222
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).