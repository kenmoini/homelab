configure-nfs-mounts
=========

This role configures NFS mounts on Linux systems.  It will install the needed packages, create the mount points, and mount the NFS shares.

This is how I configure common mounts on all my systems.

Requirements
------------

- An NFS server with active exports?

Role Variables
--------------

```yaml
#==============================================================================
# defaults for the role

# NFS version
nfs_version: 3

# Default NFS4 mount options
nfs_mount_opts: rw,relatime

#==============================================================================
# OS specific variables, example for RHEL

# nfs_packages is the list of packages to install
nfs_packages:
- nfs-utils

#==============================================================================
# Input variables for the role

# nfs_mounts is a list of NFS mounts to configure
nfs_mounts:
- path: "/mnt/remoteWork" # the path to mount the NFS share to
  src: "deep-thought.kemo.labs:/nfs-fast/remoteWork" # the source of the NFS mount, in the format of server:/path/to/share
  #opts: "rw,relatime" # optional, the mount options to use, defaults to rw,relatime
  #dump: 0 # optional, the dump value to use, defaults to omit
  #passno: 0 # optional, the pass number to use, defaults to omit
  #state: "mounted" # optional, the state of the mount, defaults to mounted
  #boot: true # optional, whether or not to mount the share at boot, defaults to true

- path: "/mnt/ISOs"
  src: "deep-thought.kemo.labs:/ISOs"
```

Dependencies
------------

None

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
  - { role: configure-nfs-mounts, nfs_mounts: [{'src': 'nfs.example.com:/path/to/export', 'path': '/path/to/mount'}] }

- name: Other play for other servers
  hosts: other_servers
  tasks:
  - name: Include the role this way
    include_role:
      name: configure-nfs-mounts
    vars:
      nfs_mounts:
      - src: nfs.example.com:/path/to/export
        path: /path/to/mount
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).
