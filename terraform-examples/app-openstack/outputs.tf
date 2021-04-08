# output
output "color" {
  description = "color"
  value       = var.color
}
locals {
  blue_private_ip = flatten(module.blue_api[*].private_ip)
  blue_public_ip  = flatten(module.blue_api[*].public_ip)
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
  # value = openstack_orchestration_stack_v1.web.outputs
  depends_on = [
    module.web
    #openstack_orchestration_stack_v1.web
  ]
}
output "api_stack_output" {
  value = module.blue_api[*].stack_output
  # value = openstack_orchestration_stack_v1.web.outputs
  depends_on = [
    module.blue_api
    #openstack_orchestration_stack_v1.web
  ]
}

