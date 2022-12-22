terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  alias = "local"
  uri = "qemu:///system"
}

provider "libvirt" {
  alias = "serenity"
  uri   = "qemu+ssh://root@serenity.kemo.labs/system"
}

provider "libvirt" {
  alias = "rocinante"
  uri   = "qemu+ssh://root@rocinante.kemo.labs/system"
}

provider "libvirt" {
  alias = "raza"
  uri   = "qemu+ssh://root@raza.kemo.labs/system"
}