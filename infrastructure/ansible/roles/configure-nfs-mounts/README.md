configure-nfs-mounts
=========

This role configures NFS mounts on Linux systems.  It will install the needed packages, create the mount points, and mount the NFS shares.

This is how I configure common mounts on all my systems.

Requirements
------------

- An NFS server with active exports?

Role Variables
--------------

- `nfs_packages` - A list of packages that are installed, the variable is traditionally loaded from the `vars/{{ ansible_os_family }}.yml` file.
- `nfs_version` - The version of NFS to use.  Defaults to `3`.
- `nfs_mount_opts` - The mount options to use.  Defaults to `rw,relatime`.
- `nfs_mounts` - A list of NFS Mounts that can be defined as:
  - `src` - The source of the NFS mount, in the format of `server:/path/to/share`.
  - `path` - The path to mount the NFS share to.
  - `opts` - Optional. The mount options to use.  Defaults to `rw,relatime`.
  - `dump` - Optional. The dump value to use.  Defaults to `omit`.
  - `passno` - Optional. The pass number to use.  Defaults to `omit`.
  - `state` - Optional. The state of the mount.  Defaults to `mounted`.
  - `boot` - Optional. Whether or not to mount the share at boot.  Defaults to `true`.

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
