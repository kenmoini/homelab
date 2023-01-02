setup-ipa-client
=========

This role will install all the needed packages in order to configure the RHEL/Debian host to join a FreeIPA/IDM domain/realm.

Requirements
------------

None

Role Variables
--------------

```yaml
#==============================================================================
# defaults for the role

# enable_nfs_home enables automounting of NFS home directories if that's configured on the FreeIPA server
enable_nfs_home: true

# reboot_after_join enables rebooting the node if it just joined, helpful if you want to do the automounting of NFS home directories
reboot_after_join: true

# reboot_wait_timeout is the number of seconds to wait for the node to come back online after rebooting
reboot_wait_timeout: 3600

#==============================================================================
# OS specific variables, example for RHEL

ipa_client_packages:
- shadow-utils
- ipa-client
- oddjob
- autofs
# the following are opinionated for my setup
- zsh
- bash-completion
- nano
- perl

#==============================================================================
# Input variables for the role

# freeipa_domain is the domain to join
freeipa_domain: example.com

# freeipa_realm is the realm to join - you can most times leave this as the default
freeipa_realm: "{{ freeipa_domain | upper }}"

# freeipa_server is the hostname of the FreeIPA server to authenticate against
freeipa_server: idm.example.com

# freeipa_principal is the principal to use for authentication, usually admin
freeipa_principal: admin

# freeipa_password is the password to use for authentication - all this information should be stored in a vault, eg `ansible-vault create site-configs/host.example.com/freeipa-vault.yml`
freeipa_password: "someSecurePassword"
```

Dependencies
------------

None

Example Playbook
----------------


```yaml
- hosts: servers
  roles:
   - { role: setup-ipa-client, freeipa_domain: example.com, freeipa_server: idm.example.com, freeipa_principal: admin }

- name: Other play with other hosts including the role in another way
  hosts: otherServers
  tasks:
  - name: Include the role
    include_role:
      name: setup-ipa-client
    vars:
      freeipa_domain: example.com
      freeipa_server: idm.example.com
      freeipa_principal: admin
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).