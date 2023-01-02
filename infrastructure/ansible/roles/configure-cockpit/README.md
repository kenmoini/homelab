configure-cockpit
=========

This role installs and configures Cockpit Web Console on Linux systems.  This is basically how I enforce the configuration of Cockpit to stop prompting me for Kerberos sign-in.

Requirements
------------

None

Role Variables
--------------

None.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: configure-cockpit }

- name: Other play for other servers
  hosts: other_servers
  tasks:
    - name: Include the role this way
      include_role:
        name: configure-cockpit
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).