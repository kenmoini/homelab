


resource "libvirt_volume" "serenity_k8s_cp_1" {
  provider = libvirt.serenity
  count    = 3
  name     = "serenity-k8s-cp-${count.index}"
  pool     = "default"
  format   = "qcow2"
  size     = 10000
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = "#cloud-config"
}

resource "libvirt_domain" "serenity_k8s_cp_1" {
  count    = 3
  provider = libvirt.serenity
  name     = "k8s-cp-${count.index}"
  memory   = "4096"
  vcpu     = 4

  disk {
    volume_id = element(libvirt_volume.serenity_k8s_cp_1.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

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
    bridge = "br0"
    mac    = "52:54:00:b2:2f:86"
  }

  boot_device {
    dev = ["hd", "network"]
  }
}
