# Clout-init definitions
data "template_file" "k8s_cp_1_user_data" {
  template = file("${path.module}/cloud-inits/control-plane-1.cfg")
}

data "template_file" "k8s_cp_2_user_data" {
  template = file("${path.module}/cloud-inits/control-plane-2.cfg")
}

data "template_file" "k8s_cp_3_user_data" {
  template = file("${path.module}/cloud-inits/control-plane-3.cfg")
}

resource "libvirt_cloudinit_disk" "k8s_cp_1_user_data_commoninit" {
  provider = libvirt.serenity
  name      = "k8s-cp-1-ubuntu-cloudinit.iso"
  user_data = data.template_file.k8s_cp_1_user_data.rendered
  pool = "serenity-1"
}

resource "libvirt_cloudinit_disk" "k8s_cp_2_user_data_commoninit" {
  provider = libvirt.rocinante
  name      = "k8s-cp-2-ubuntu-cloudinit.iso"
  user_data = data.template_file.k8s_cp_2_user_data.rendered
  pool = "rocinante"
}

resource "libvirt_cloudinit_disk" "k8s_cp_3_user_data_commoninit" {
  provider = libvirt.serenity
  name      = "k8s-cp-3-ubuntu-cloudinit.iso"
  user_data = data.template_file.k8s_cp_3_user_data.rendered
  pool = "serenity-1"
}