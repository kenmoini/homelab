install-base-packages
=========

Installs a set of base packages for a system.  This is how I make sure nano is on all of my systems.

Requirements
------------

None.

Role Variables
--------------

- `universal_packages` - A list of packages that are installed on all Linux systems
- `base_packages` - A list of packages that are installed on distribution-specific systems.  The variable is traditionally loaded from the `vars/{{ ansible_os_family }}.yml` file.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: install-base-packages, universal_packages: ['nano', 'bash-completion'] }

- name: Other play for other servers
  hosts: other_servers
  tasks:
  - name: Include the role this way
    include_role:
      name: install-base-packages
    vars:
      universal_packages:
      - nano
      - bash-completion
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).