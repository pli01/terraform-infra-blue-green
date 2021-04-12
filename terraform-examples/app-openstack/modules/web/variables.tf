variable "fip" {
  type    = string
}

variable "network" {
  type    = string
}
variable "subnet" {
  type    = string
}
variable "source_volid" {
  type    = string
}

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
variable "color" {
  type    = string
}

variable "api_server" {
  type    = string
}

variable "user_data" {
  type    = string
}
