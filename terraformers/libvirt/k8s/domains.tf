resource "libvirt_domain" "serenity_k8s_cp_1" {
  provider = libvirt.serenity
  name     = "k8s-cp-1"
  memory   = "8192"
  vcpu     = 4

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_1_user_data_commoninit.id

  disk {
    volume_id = libvirt_volume.serenity_k8s_cp_1.id
  }
  
  autostart = true

  boot_device {
    dev = ["hd", "network"]
  }

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
  #  listen_address = var.serenity_host_ip
  #  autoport    = true
  #}
  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = var.serenity_host_ip
    autoport    = true
  }
}

resource "libvirt_domain" "rocinante_k8s_cp_2" {
  provider = libvirt.rocinante
  name     = "k8s-cp-3"
  memory   = "8192"
  vcpu     = 4

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  disk {
    volume_id = libvirt_volume.rocinante_k8s_cp_2.id
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_2_user_data_commoninit.id
  
  autostart = true

  boot_device {
    dev = ["hd", "network"]
  }

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
  #  listen_address = var.rocinante_host_ip
  #  autoport    = true
  #}
  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = var.rocinante_host_ip
    autoport    = true
  }
}

resource "libvirt_domain" "serenity_k8s_cp_3" {
  provider = libvirt.serenity
  name     = "k8s-cp-3"
  memory   = "8192"
  vcpu     = 4

  network_interface {
    bridge = var.vm_bridge
    #mac    = "52:54:00:b2:2f:86"
  }

  disk {
    volume_id = libvirt_volume.serenity_k8s_cp_3.id
  }

  cloudinit = libvirt_cloudinit_disk.k8s_cp_3_user_data_commoninit.id
  
  autostart = true

  boot_device {
    dev = ["hd", "network"]
  }

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
  #  listen_address = var.serenity_host_ip
  #  autoport    = true
  #}
  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = var.serenity_host_ip
    autoport    = true
  }
}
