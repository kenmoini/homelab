# Uncomment these resources if you need to create the pools

#resource "libvirt_pool" "serenity" {
#  name = "serenity"
#  type = "dir"
#  path = "/mnt/nfs/vms/serenity"
#}
#
#resource "libvirt_pool" "rocinante" {
#  name = "rocinante"
#  type = "dir"
#  path = "/mnt/nfs/vms/rocinante"
#}
#
#resource "libvirt_pool" "raza" {
#  name = "raza"
#  type = "dir"
#  path = "/mnt/nvme_7TB/nfs/vms/raza"
#}