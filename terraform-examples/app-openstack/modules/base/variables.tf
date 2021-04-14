# defines variables in variables.tf
#### network
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

# security
variable "ssh_access_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

#### MAIN DISK SIZE FOR INSTANCE
variable "vol_size" {
  type    = number
  default = 10
}

variable "vol_type" {
  type    = string
  default = "default"
}

variable "image" {
  type    = string
  default = "debian-latest"
}
variable "most_recent_image" {
  default = "false"
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


