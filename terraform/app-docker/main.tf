terraform {
  required_version = ">= 0.12"
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
# define provider
provider "docker" {}

# declare any input variables
# defines variables in variables.tf
# override variable in File "terraform.tfvars" or in cli -var key=value or TF_VAR_var=value
variable "color" {
  description = "color"
  default     = "blue"
  type        = string
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

variable "api_blue_count" {
  description = "api_blue_count"
  type        = number
  default     = 1
}

variable "api_green_count" {
  description = "api_green_count"
  type        = number
  default     = 1
}

variable "api_image_blue" {
  description = "api_image_blue"
  default     = "python:3"
}

variable "api_image_green" {
  description = "api_image_green"
  default     = "python:3"
}

# create docker network resource
resource "docker_network" "private_network" {
  name = "my_network"
}

# data registry image name
data "docker_registry_image" "web" {
  name = "nginx:stable"
}

resource "docker_image" "web" {
  keep_locally  = true
  name          = data.docker_registry_image.web.name
  pull_triggers = [data.docker_registry_image.web.sha256_digest]
}

# create web container
resource "docker_container" "web" {
  count   = var.web_count
  name    = "web-${count.index + 1}"
  image   = docker_image.web.latest
  restart = "always"
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = "80"
    external = var.web_port + count.index
  }
  volumes {
    host_path      = abspath("${path.module}/nginx-conf.d/api.conf.template")
    container_path = "/etc/nginx/templates/default.conf.template"
    read_only      = true
  }
  env = [
    "COLOR=${var.color}",
    format("API_SERVER=%s", join(" ", formatlist("%s %s:%s;", "server", flatten(local.active_server_name), var.api_port))),
  ]
}

locals {
  is_blue            = (var.color == "blue" ? true : false)
  active_server_name = (local.is_blue ? module.api-blue[*].name : module.api-green[*].name)
}

module "api-blue" {
  source       = "./modules/api"
  color        = "blue"
  prefix_name  = "api"
  maxcount     = var.api_blue_count
  api_image    = var.api_image_blue
  network_name = docker_network.private_network.name
}

module "api-green" {
  source       = "./modules/api"
  color        = "green"
  prefix_name  = "api"
  maxcount     = (local.is_blue ? 0 : var.api_green_count) # enable green
  api_image    = var.api_image_green
  network_name = docker_network.private_network.name
}

# output
output "color" {
  description = "color"
  value       = var.color
}
output "web-ip" {
  description = "web ip"
  value       = docker_container.web[*].ip_address
}
output "web-port" {
  description = "web port"
  value       = docker_container.web[*].ports
}
output "api-blue-name" {
  description = "api blue name"
  value       = flatten(module.api-blue[*].name)
}

output "api-blue-ip" {
  description = "api blue ip"
  value       = flatten(module.api-blue[*].ip_address)
}
output "api-green-ip" {
  description = "api green ip"
  value       = flatten(module.api-green[*].ip_address)
}
