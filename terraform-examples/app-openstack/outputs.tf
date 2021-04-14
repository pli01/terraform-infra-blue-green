# output
output "color" {
  description = "color"
  value       = var.color
}
locals {
  blue_private_ip = flatten(module.blue_api[*].private_ip)
  blue_public_ip  = flatten(module.blue_api[*].public_ip)
  web_private_ip  = flatten(module.web[*].private_ip)
  web_id          = flatten(module.web[*].id)
}
### outputs
output "api_stack_private_ip" {
  value = local.active_server_ip
  depends_on = [
    local.blue_private_ip
  ]
}

output "blue_api_stack_private_ip" {
  value = local.blue_private_ip
  depends_on = [
    local.blue_private_ip
  ]
}
output "blue_api_stack_public_ip" {
  value = local.blue_public_ip
  depends_on = [
    local.blue_public_ip
  ]
}

output "web_stack_output" {
  value = module.web.stack_output
  depends_on = [
    module.web
  ]
}
output "api_stack_output" {
  value = module.blue_api[*].stack_output
  depends_on = [
    module.blue_api
  ]
}

output "web_id" {
  value = local.web_id
}
output "web_private_ip" {
  value = local.web_private_ip
}
output "web_public_ip" {
  value = module.base.web_address
}

