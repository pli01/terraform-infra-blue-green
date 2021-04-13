variable "fip" {
  type    = string
  default = ""
}

variable "color" {}
variable "maxcount" {}
variable "prefix_name" {}
variable "network" {}
variable "subnet" {}
variable "source_volid" {}

variable "security_group" {
  type    = string
}

#### GLANCE
variable "image" {
  type    = string
  default = "debian-latest"
}

variable "vol_type" {
  type    = string
  default = "default"
}

#### VM HTTP parameters ####
variable "key_name" {
  type    = string
  default = "debian"
}

variable "flavor" {
  type    = string
  default = "t1.small"
}

#### Variable used in heat and cloud-init
variable "affinity_group" {}
variable "user_data" {}
