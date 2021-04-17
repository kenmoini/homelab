#!/bin/bash

VERSION_TAG="0.6.3"
export CGO_ENABLED="1"

mkdir -p ~/.tmpBuild
cd ~/.tmpBuild

git clone https://github.com/dmacvicar/terraform-provider-libvirt
cd terraform-provider-libvirt

git checkout $VERSION_TAG

mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/$VERSION_TAG/linux_amd64

make

cd ~
rm -rf ~/.tmpBuild