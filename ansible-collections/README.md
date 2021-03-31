# Home Lab - Ansible Collections

Here you can find a number of resources to help deploy workloads this repository supports via CaaS and otherwise.

## Prerequisites

### Install Required Collections from Galaxy Hub

There are a number of collections these assets need to execute - install them all via the following command:

```bash
ansible-galaxy install -r collections/requirements.yml
```

### Set up Secrets

In the `vars` directory you can find a file called `example.secrets.yml` which has all the secret variable basic definitions needed to execute the Playbooks.

Copy that `example.secrets.yml` file to `secrets.yml` and modify where needed.  Then run the following command to encrypt the variable file:

```bash
ansible-vault encrypt vars/secrets.yml
```

This encrypted variable file can now be stored in a Git repo safely (as long as no one knows the password to decrypt it that is...)

## Cheat Sheet

#### Deploy DNS Core CaaS

```bash
ansible-playbook -k -i inventory deploy-caas-dns-core-1.yml
ansible-playbook -k -i inventory deploy-caas-dns-core-2.yml
```

#### Deploy PiHole DNS CaaS

```bash
ansible-playbook -k -i inventory -e "piholeWebPassword=yourPassword" -e "clearVolumes=true" deploy-caas-dns-pihole-1.yml
ansible-playbook -k -i inventory -e "piholeWebPassword=yourPassword" -e "clearVolumes=true" deploy-caas-dns-pihole-2.yml
```

#### Deploy NFS Server CaaS

```bash
ansible-playbook -k -i inventory deploy-caas-nfs.yml
```