variable "project_name" {
    type = string
}

variable "credentials" {
  type = string
  description = "Path to the JSON file with the service account credentials."
}

variable "network_name" {
    type = string
    default = "gevorg_lab_network"
}

variable "machine_type" {
    type = string
    default = "g1-small"
}

variable "num_vms" {
    type = number
    default = "3"
}

variable "ssh_key" {
    type = string
}

variable "zone" {
    type = string
}