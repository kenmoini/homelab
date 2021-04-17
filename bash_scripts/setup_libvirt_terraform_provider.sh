#!/bin/bash

VERSION_TAG="0.6.3"
export CGO_ENABLED="1"

mkdir -p ~/.tmpBuild
cd ~/.tmpBuild

dnf install golang make "@Development Tools" libvirt-devel -y

git clone https://github.com/dmacvicar/terraform-provider-libvirt
cd terraform-provider-libvirt

git checkout v$VERSION_TAG

mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/$VERSION_TAG/linux_amd64

make

mv terraform-provider-libvirt ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/$VERSION_TAG/linux_amd64/terraform-provider-libvirt

cd ~
rm -rf ~/.tmpBuild