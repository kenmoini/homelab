#!/bin/bash

SERVER_HOSTNAME="idm.kemo.labs"
SERVER_IP="192.168.42.13"

IDM_REALM="KEMO.LABS"
IDM_DOMAIN="kemo.labs"


# System must be subscribed already

# Set Hostname
hostnamectl set-hostname $SERVER_HOSTNAME

# Update base packages
dnf update -y

# Install base packages
dnf install -y nano firewalld python3-libselinux @idm:DL1

# Disable SELinux
setenforce 0

# Start firewalld
systemctl enable --now firewalld

# Set firewalld 
firewall-cmd add-service freeipa-ldap freeipa-ldaps dns ntp ssh https http --permanent
firewall-cmd add-port 8080/tcp --permanent

# Install RH IDM
dnf install -y bind \
  bind-dyndb-ldap \
  ipa-server \
  openldap-devel \
  platform-python-devel \
  ipa-server-common \
  ipa-server-dns \
  ipa-server-trust-ad \
  krb5-devel \
  python36-devel \
  python3-ipapython \
  python3-six \
  python3-dns \
  python3-cffi \
  python3-idna \
  python3-netaddr \
  python3-gssapi \
  python3-decorator \
  python3-pyasn1 \
  python3-jwcrypto \
  python3-pyOpenSSL \
  python3-cryptography \
  python3-pytest \
  python3-ldap \
  python3-argcomplete \
  python3-argh \
  "@Development tools"