# Homelab

This repository has a series of resources used to quickly stand up home lab environments.

## Why?

I frequently need to rearchitect my limited resources and have to redeploy hypervisors, container platforms, services, and so on.  This is the one-stop-shop for how I recreate my home lab environment, with almost everything from core network services to Red Hat and other enterprise product testing environments.

## Containers-as-a-Service

Traditionally, you'd like to have a few services set up but in a home lab environment resources can sometimes be at a premium.  Instead of beefy VMs, why not run your services as containers that are launched as SystemD Services with Podman?!

In the `containers-as-a-service` directory you can find resources that define different containerized workloads such as DNS.

## Ansible Collections

Often times it's useful to use an automation platform like Ansible to handle system and service configuration as fast and as repeatable as possible.  

In the `ansible-collections` directory you can find a series of collections to help bootstrap an Ansible Tower server with the collections, to other collections that will configure systems for workloads such as Red Hat Satellite, and OpenShift.

## Bash Scripts

The trusted methods of automation: Bash.

There are some scripts for:

- Setting up an OpenShift Assisted Installer cluster across a few nodes with PCI devices passed through via Libvirt/KVM
- Creating a standard VM via Libvirt, set for Red Hat Identity Management
- Unattended Install & Configuring of RH IDM on RHEL 8.3

## OpenShift Quickstarts

If there's one thing that is deployed more often than my Homelab infrastructure it's OpenShift clusters - sometimes go through a few a day!

In order to make bootstrapping a vanilla OpenShift and deploying workloads easier there are a few scripts and manifests provided to do the following:

### Initializing a Cluster

- Styling the OpenShift login in red Matrix-style dripping text
- NFS Backing for the Internal Registry
- NFS StorageClass with Dynamic Provisioner
- Red Hat Subscription Manager Cluster entitlement to use normal RHEL repos in UBI containers
- NFD+GPU Operator deployment

### Example Workloads

WIP