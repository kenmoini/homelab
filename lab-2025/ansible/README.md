# Lab 2025 - Ansible Deployment

So my lab had an extended vacation, and once it got back to work it forgot how to do, well, anything really.  So instead of trying to spend a lot of time to fix broken things, I figured it was a great chance to redo everything in a hopefully better way!

And now my homelab has:

- **Chrony** - Time server to keep things N-SYNC!
- **PiHole** - Ad blocking via DNS!
- **Shared Database Services** - PostgreSQL and MySQL as a shared database that can hose everything all at once!
- **PowerDNS** - Authoritative and Recursive DNS services!
- **JFrog Artifactory** - Local private and proxy pull-through cache for container images to avoid Docker Hub pull limits!
- **NGINX Proxy Manager** - Ingress/Reverse proxy to edge terminate TLS across all my services on nice URLs!
- **OpenVPN Server** - Backup VPN cause I'm paranoid!
- **StepCA** - ACME CA and other things if I can ever them figure out!
- **Hashicorp Vault** - Secrets, shhhhh!
- **Squid** - Outbound HTTP Proxy with optional SSL Re-encryption!
- **FreeIPA** - Identity Management with LDAP!
- **Keycloak** - Single Sign On, extends FreeIPA with SAML/OIDC!
- **Homepage** - A hella sweet dashboard at https://kemo.labs
- **Metrics Stack** - Obligatory Prometheus, Alertmanager, Grafana, Node Exporter stack!
- **NetBox** - DDI and IPAM Overkill!
- **TFTP** - For bootstrapping PXE boot!
- **NGINX** - (Dropbox) Simple HTTP server for hosting things!
- **Gitea** - Local source code management cause ACM is a pain in the ass!
- **OpenObserve** - Another observability service that seems ok!

And this all runs in containers!  The only VM I have is the Home Assistant appliance.

To others and/or Future Ken: I'd deploy the services in the order above.

Everything can run on a single host with some decent resources - running all these services takes about 36GB of RAM and a few good cores, this MS-01 called Normandy makes little work of all this.

## Prerequisites

- A host with Podman
- Some IPs - while some deployments can share an IP in the Shared Pod, some workloads need their own IP, namely:
  - NGINX Proxy Manager
  - 