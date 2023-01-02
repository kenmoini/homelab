add-root-ca-certs
=========

Downloads Root CA certificates from a web server and adds them to the system's trusted root CA certificates.

Requirements
------------

None

Role Variables
--------------

```yaml
#==============================================================================
# default variables for the role

# additionalTrustedRootCerts is a list of URLs to PEM encoded root CA certificates
additionalTrustedRootCerts:
- https://github.com/kenmoini/homelab/raw/main/pki/root-authorities/serto-root-ca.pem
- https://github.com/kenmoini/homelab/raw/main/pki/root-authorities/klstep-ca.pem
- https://github.com/kenmoini/homelab/raw/main/pki/root-authorities/pgv-root-ca.pem

#==============================================================================
# OS specific variables, example for RHEL

# pem_path is the path to the directory where the root CA certificates will be stored
pem_path: "/etc/pki/ca-trust/source/anchors"

# cert_file_extension is the file extension for the root CA certificates
cert_file_extension: "pem"

# update_command is the command to run to update the system's trusted root CA certificates
update_command: "update-ca-trust"

```
Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - { role: add-root-ca-certs, additionalTrustedRootCerts: ['https://ca.example.com/root-ca.cert.pem'] }

- name: Other play with other servers to configure
  hosts: other_servers
  tasks:
    - name: Include the role
      include_role:
        name: add-root-ca-certs
        tasks_from: main
      vars:
        additionalTrustedRootCerts:
        - https://ca.example.com/root-ca.cert.pem
        - https://ca.example.com/other-root-ca.cert.pem
```

License
-------

MIT

Author Information
------------------

This is a garbage role written by Ken Moini. You can find me on [Twitter](https://twitter.com/kenmoini) and [GitHub](https://github.com/kenmoini) and some other fun things at my [personal site](https://kenmoini.com).