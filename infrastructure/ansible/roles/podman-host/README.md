podman-host
=========

Installs and configures a Linux host to run Podman and containers.

Requirements
------------

None.

Role Variables
--------------

```yaml
#==============================================================================
# OS specific variables, example for RHEL

podman_packages:
- podman
- udica
- buildah
- skopeo
- cockpit-podman
- podman-docker
- container-tools
```

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
  - { role: podman-host }

- name: Other play with other servers to configure
  hosts: other_servers
  tasks:
  - name: Include the role
    include_role:
      name: podman-host
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).