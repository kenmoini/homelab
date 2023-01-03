# Homelab

> This document serves as an entrypoint to the architecture, documentation, and related assets that comprise my homelab.  Old things are archived in the [legacy](legacy) directory.

## Infrastructure

I try to standardize my infrastructure as much as possible - certainly at least their configuration.

Ansible is what drives my configuration across my fleet of physical RHEL hosts and virtual machines that are a mix of RHEL, Fedora, and Ubuntu.

In the [infrastructure/](infrastructure/) directory there is more information about the things related to the deployment and configuration states of my infrastructure, such as the Kickstart files used to provision the systems and the Ansible Collections that I use to configure the systems.

---

## Services

| xHost |  xSvc | GitOps | CaC | CaaS | Name                                                                                            |
|-------|-------|--------|-----|------|-------------------------------------------------------------------------------------------------|
|   x   |   x   |   x    |  x  |  x   | [Authoritative DNS with GoZones](https://github.com/kenmoini/lab-go-zones-dns)                  |
|   x   |   x   |   x    |  x  |  x   | [Recursive DNS with Pi-Hole](https://github.com/kenmoini/lab-pihole)                            |
|   x   |   x   |   x    |  x  |  x   | [ZeroTier SD-WAN VPN](https://github.com/kenmoini/lab-zerotier)                                 |
|   x   |   x   |   x    |  x  |  x   | [Keycloak SSO](https://github.com/kenmoini/lab-keycloak)                                        |
|   x   |   x   |   x    |  x  |  x   | [Ingress with HAProxy Reverse Proxy and Nginx+Certbot](https://github.com/kenmoini/lab-ingress) |
|   x   |   x   |   x    |  x  |  x   | [Dashy](https://github.com/kenmoini/lab-dashy)                                                  |
|   -   |   -   |   -    |  -  |  x   | WIP - Grafana/Prometheus/Alertmanager Metrics Stack                                             |
|   -   |   -   |   -    |  -  |  x   | WIP - Squid Proxy                                                                               |
|   -   |   -   |   -    |  -  |  x   | WIP - Sushy Tools                                                                               |
|   -   |   -   |   -    |  -  |  x   | WIP - OpenVPN                                                                                   |
|   -   |   -   |   -    |  -  |  x   | WIP - Sonatype Nexus                                                                            |
|   -   |   -   |   -    |  -  |  x   | WIP - Assisted Installer                                                                        |

**xHost** = Multiple Hosts | **xSvc** = Multiple Services on a Host | **GitOps** = GitOps automation driven | **CaC** = Configuration as Code (usually YAML) | **CaaS** = Container as a Service

---

## Deployment Process

My ideal homelab can be set up by:

- Planning out the networks, resources, etc
- Setting up the core routing services (Unifi Dream Machine Pro, Switches, etc) - use upstream DNS until the bootstrap/core node is running DNS conntainers
- Stand up one physical host to run a couple containers for DNS and a VM for Tower, which then automates the rest of the lab almost entirely.
- Additional physical hosts can be added by booting their Kickstarts during install then targeting and running the desired automation against them.

### Order of Operations

- Stand up one of the physical servers as a bootstrap/core node - Operating System installs are via Kickstarts that configure a host with the intended:
  - Networking
  - Storage configuration
  - SSH keys
  - RHSM Credentials
  - Default DVD packages
  - NFS Mounts (?)
  - IDM Configuration [Optional, if not bootstrap node]
- The physical host is used to run some Ansible automation via the CLI:
  - Bootstrapping of the physical host with things such as Libvirt/KVM and Podman configuration - via the Ansible CLI
  - Deployment of core network service containers:
    - DNS
    - Pi-Hole
  - Reconfiguration of NICs to use new DNS
  - Creation of a RHEL VM, which is then bootstrapped with Ansible Tower/AAP2 Controller - via the Ansible CLI
  - Configuration of that Ansible Tower/AAP2 Controller instance - via the Ansible CLI
- The Tower/Controller instance is then used to configure the rest of the lab's automation and systems with a Workflow Job in the following order:
  - Creation of the Libvirt VMs on the bootstrap/core node for:
    - StepCA
    - IDM
    - Quay
    - Virtual Bare Metal VM Shells for Sushy
  - Deployment of additional workloads such as:
    - OpenVPN
    - ZeroTier
    - Keycloak SSO
    - Dashy
    - Metrics
    - Squid Proxy
    - Sushy Tools
    - Sonatype Nexus
    - Assisted Installer Service

The state of those services and VMs should be largely stored in a Git repo, so it should just need running the automation to complete the deployment tasks.

As new physical and virtual servers are brought online then all that's needed is to enable them in the Inventory and set up their site configurations - the `git push` of the site configs should trigger everything.

---

## Robots

For things that aren't easily put in a little box like "Service" or "Workload" but do provide a service and are run as some sort of workload.

- [lab-ansible-stairmaster](https://github.com/kenmoini/lab-ansible-stairmaster) - SSL Management in multiple formats, for multiple services, on multiple hosts - created and signed by a StepCA Server and distributed by Ansible.  This is how I sign certificates for things such as services running in containers like my Ingress that need an HAProxy certificate, to the Cockpit instances on all my systems that take them in cert/key pairs.  Runs on a schedule to keep everything rotated nice and right.