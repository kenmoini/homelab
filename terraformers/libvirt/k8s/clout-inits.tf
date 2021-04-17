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
  name      = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.10-live-server-amd64.iso"
  user_data = data.template_file.k8s_cp_1_user_data.rendered
}

resource "libvirt_cloudinit_disk" "k8s_cp_2_user_data_commoninit" {
  name      = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.10-live-server-amd64.iso"
  user_data = data.template_file.k8s_cp_2_user_data.rendered
}

resource "libvirt_cloudinit_disk" "k8s_cp_3_user_data_commoninit" {
  name      = "/mnt/nvme_7TB/nfs/isos/ubuntu-20.10-live-server-amd64.iso"
  user_data = data.template_file.k8s_cp_3_user_data.rendered
}