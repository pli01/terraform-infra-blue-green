variable "fip" {}

variable "network" {}
variable "subnet" {}
variable "source_volid" {}

variable "no_proxy" {}
variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}

variable "security_group" {}


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
variable "color" {}
variable "api_server" {}
