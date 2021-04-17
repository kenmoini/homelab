


resource "libvirt_volume" "serenity_k8s_cp_1" {
  provider = libvirt.serenity
  name     = "serenity-k8s-cp-1"
  pool     = "serenity-1"
  format   = "qcow2"
  #source = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}
resource "libvirt_volume" "rocinante_k8s_cp_2" {
  provider = libvirt.rocinante
  name     = "rocinante-k8s-cp-2"
  pool     = "rocinante"
  format   = "qcow2"
  #source = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}
resource "libvirt_volume" "serenity_k8s_cp_3" {
  provider = libvirt.serenity
  name     = "serenity-k8s-cp-3"
  pool     = "serenity-1"
  format   = "qcow2"
  #source = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}

resource "libvirt_domain" "serenity_k8s_cp_1" {
  provider = libvirt.serenity
  name     = "k8s-cp-1"
  memory   = "8192"
  vcpu     = 4

  disk {
    volume_id = libvirt_volume.serenity_k8s_cp_1.id
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_1_user_data_commoninit.id

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
  #graphics {
  #  type        = "vnc"
  #  listen_type = "address"
  #  autoport    = true
  #}

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  boot_device {
    dev = ["hd", "network"]
  }
}

resource "libvirt_domain" "rocinante_k8s_cp_2" {
  provider = libvirt.rocinante
  name     = "k8s-cp-3"
  memory   = "8192"
  vcpu     = 4

  disk {
    volume_id = libvirt_volume.rocinante_k8s_cp_2.id
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_2_user_data_commoninit.id

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  #graphics {
  #  type        = "spice"
  #  listen_type = "address"
  #  autoport    = true
  #}
  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  boot_device {
    dev = ["hd", "network"]
  }
}

resource "libvirt_domain" "serenity_k8s_cp_3" {
  provider = libvirt.serenity
  name     = "k8s-cp-3"
  memory   = "8192"
  vcpu     = 4

  disk {
    volume_id = libvirt_volume.serenity_k8s_cp_3.id
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_3_user_data_commoninit.id

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  #graphics {
  #  type        = "spice"
  #  listen_type = "address"
  #  autoport    = true
  #}
  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  boot_device {
    dev = ["hd", "network"]
  }
}
