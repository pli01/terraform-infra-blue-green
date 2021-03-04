# declare any input variables
# defines variables in variables.tf
# override variable in File "terraform.tfvars" or in cli -var key=value or TF_VAR_var=value
variable "color" {
  description = "color"
  default     = "blue"
  type        = string
  validation {
    condition     = can(regex("^(blue|green)$", var.color))
    error_message = "The color value must be \"blue\" or \"green\". Default: \"blue\"."
  }
}

variable "web_port" {
  description = "web_port"
  type        = number
  default     = 80
}

variable "api_port" {
  description = "api_port"
  type        = number
  default     = 9000
}

variable "web_count" {
  description = "web_count"
  type        = number
  default     = 1
}

variable "blue_api_count" {
  description = "blue_api_count"
  type        = number
  default     = 1
}

variable "green_api_count" {
  description = "green_api_count"
  type        = number
  default     = 1
}

variable "blue_api_image" {
  description = "blue_api_image"
  default     = "python:3"
}

variable "green_api_image" {
  description = "green_api_image"
  default     = "python:3"
}

# Params file for variables

#### GLANCE
variable "image" {
  type    = string
  default = "debian-latest"
}
variable "most_recent_image" {
  # default = "true"
  default = "false"
}
#### NEUTRON
variable "external_network" {
  type    = string
  default = "external-network"
}

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

variable "network_http" {
  type = map(string)
  default = {
    subnet_name = "subnet-http"
    cidr        = "192.168.1.0/24"
  }
}

#### MAIN DISK SIZE FOR HTTP
variable "vol_size" {
  type    = number
  default = 10
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
variable "no_proxy" {
  type    = string
  default = "localhost"
}

variable "ssh_access_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
