
variable "vm_bridge" {
  type    = string
  default = "bridge0"
}
variable "kvm_image_source" {
  type    = string
  default = "http://kemo.labs/dropbox/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}
variable "raza_host_ip" {
  type    = string
  default = "192.168.42.40"
}
variable "rocinante_host_ip" {
  type    = string
  default = "192.168.42.50"
}
variable "serenity_host_ip" {
  type    = string
  default = "192.168.42.55"
}

variable "raza_pool_name" {
  type    = string
  default = "raza"
}
variable "rocinante_pool_name" {
  type    = string
  default = "rocinante"
}
variable "serenity_pool_name" {
  type    = string
  default = "serenity-1"
}
