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

# create docker network resource
resource "docker_network" "private_network" {
  name = "my_network"
}

# data registry image name
data "docker_registry_image" "web" {
  name = "nginx:stable"
}

resource "docker_image" "web" {
#  keep_locally  = true
#  name          = data.docker_registry_image.web.name
#  pull_triggers = [data.docker_registry_image.web.sha256_digest]
  name          = "build-web"
  force_remove = true
  build {
    path      = abspath("${path.module}/nginx")
    dockerfile = "Dockerfile"
    remove = true
  }
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
  env = [
    "COLOR=${var.color}",
    format("API_SERVER=%s", join(" ", formatlist("%s %s:%s;", "server", flatten(local.active_server_name), var.api_port))),
  ]
#  volumes {
#    host_path      = abspath("${path.module}/nginx-conf.d/api.conf.template")
#    container_path = "/etc/nginx/templates/default.conf.template"
#    read_only      = true
#  }
}

locals {
  is_blue            = (var.color == "blue" ? true : false)
  active_server_name = (local.is_blue ? module.blue_api[*].name : module.green_api[*].name)
}

module "blue_api" {
  source       = "./modules/api"
  color        = "blue"
  prefix_name  = "api"
  maxcount     = var.blue_api_count
  api_image    = var.blue_api_image
  network_name = docker_network.private_network.name
}

module "green_api" {
  source       = "./modules/api"
  color        = "green"
  prefix_name  = "api"
  maxcount     = (local.is_blue ? 0 : var.green_api_count) # enable green
  api_image    = var.green_api_image
  network_name = docker_network.private_network.name
}

# output
output "color" {
  description = "color"
  value       = var.color
}
output "web_ip" {
  description = "web ip"
  value       = docker_container.web[*].ip_address
}
output "web_port" {
  description = "web port"
  value       = docker_container.web[*].ports
}
output "blue_api_name" {
  description = "blue api name"
  value       = flatten(module.blue_api[*].name)
}
output "green_api_name" {
  description = "green api name"
  value       = flatten(module.green_api[*].name)
}
output "blue_api_ip" {
  description = "blue api ip"
  value       = flatten(module.blue_api[*].ip_address)
}
output "green_api_ip" {
  description = "green api ip"
  value       = flatten(module.green_api[*].ip_address)
}
