resource "libvirt_volume" "serenity_k8s_cp_1" {
  provider = libvirt.serenity
  name     = "serenity-k8s-cp-1"
  pool     = var.serenity_pool_name
  format   = "qcow2"
  source = var.kvm_image_source
}
resource "libvirt_volume" "rocinante_k8s_cp_2" {
  provider = libvirt.rocinante
  name     = "rocinante-k8s-cp-2"
  pool     = var.rocinante_pool_name
  format   = "qcow2"
  source = var.kvm_image_source
}
resource "libvirt_volume" "serenity_k8s_cp_3" {
  provider = libvirt.serenity
  name     = "serenity-k8s-cp-3"
  pool     = var.serenity_pool_name
  format   = "qcow2"
  source = var.kvm_image_source
}