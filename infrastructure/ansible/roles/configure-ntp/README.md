configure-ntp
=========

Installs and configures NTP (chrony, really) on a Linux system.

Requirements
------------

None

Role Variables
--------------

```yaml
#==============================================================================
# defaults for configure-ntp

# ntp_servers is a list of NTP servers to use.  This is only used if `ntp_upstream_source` is set to `servers`.
ntp_servers:
- 0.pool.ntp.org
- 1.pool.ntp.org
- 2.pool.ntp.org
- 3.pool.ntp.org

# ntp_pools is a list of NTP pools to use.  This is only used if `ntp_upstream_source` is set to `pools`.
ntp_pools:
- time.apple.com

# ntp_upstream_source is the source of NTP servers to use.  Valid values are `servers` or `pools`.
ntp_upstream_source: pools

# ntp_timezone is the timezone to set on the system.
ntp_timezone: America/New_York

#==============================================================================
# OS specific variables, example for RHEL

# The NTP package to install
ntp_package: chrony

# The path where the configuration file should be placed
ntp_config_file_path: /etc/chrony.conf

# The name of the service that should be restarted after configuration
ntp_service_name: chronyd

#==============================================================================
# Input variables for the role

# ntp_configuration is a dictionary that contains the configuration for NTP.
ntp_configuration:
  # mode is the mode to run NTP in.  Valid values are `client` or `server` though only client is supported at this time.
  mode: client

  # timezone is optional and is the timezone to set on the system. Defaults to `America/New_York`.
  timezone: America/New_York

  # servers is a list of servers to use.  This is only used if `upstream_source` is set to `servers`.
  servers:
    - deep-thought.kemo.labs
  
  # pools is a list of pools to use.  This is only used if `upstream_source` is set to `pools`.
  pools:
    - time.apple.com
    - 0.debian.pool.ntp.org

  # upstream_source is the source of NTP servers to use.  Valid values are `servers` or `pools`.
  upstream_source: servers
```

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: configure-ntp, ntp_configuration.upstream_source: pools }

- name: Other play with other servers to configure
  hosts: other_servers
  tasks:
  - name: Include the role
    include_role:
      name: configure-ntp
    vars:
      ntp_configuration:
        mode: client
        upstream_source: pools
        pools:
          - time.apple.com
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).