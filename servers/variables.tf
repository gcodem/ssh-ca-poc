variable "network_name" {
  type    = string
  default = "gcodem-lab-network"
}

variable "machine_type" {
  type    = string
  default = "g1-small"
}

variable "vm_count" {
  type    = number
  default = "3"
}

variable "ssh_key" {
  type = string
}

variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
