variable "color" {
  description = "color"
}
variable "maxcount" {
  description = "maxcount"
}
variable "prefix_name" {
  description = "prefix_name"
}

variable "api_image" {
  description = "api_image"
}
variable "network_name" {
  description = "network_name"
}

# data registry image name
data "docker_registry_image" "api_image" {
  name = var.api_image
}

resource "docker_image" "api_image" {
  keep_locally  = true
  name          = data.docker_registry_image.api_image.name
  pull_triggers = [data.docker_registry_image.api_image.sha256_digest]
}

# create api container
resource "docker_container" "api" {
  count   = var.maxcount
  name    = format("%s-%s-%s", var.color, var.prefix_name, count.index + 1)
  image   = docker_image.api_image.latest
  restart = "always"
  networks_advanced {
    name = var.network_name
  }
  volumes {
    host_path      = abspath("${path.module}/../../python/api.py")
    container_path = "/usr/local/src/api.py"
    read_only      = true
  }
  command = ["python", "/usr/local/src/api.py"]
  env     = ["HELLO_TARGET=${var.color}"]
  #  ports {
  #    internal = "9000"
  #    external = var.api_port + count.index
  #  }
  #  lifecycle {
  #    create_before_destroy = true
  #  }
}

output "name" {
  description = "name"
  value       = docker_container.api[*].name
}

output "ip_address" {
  description = "ip_address"
  value       = docker_container.api[*].network_data[*].ip_address
}

output "ports" {
  description = "ports"
  value       = docker_container.api[*].ports
}

