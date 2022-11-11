variable "proxmox_host" {
  type    = string
  default = "pve"
}

variable "template_name" {
  type    = string
  default = "ubuntu-2204-cloudinit-template"
}
