# output
output "color" {
  description = "color"
  value       = var.color
}
### outputs
output "api_stack" {
  value = module.blue_api[*].stack
  depends_on = [
    module.blue_api
    #openstack_orchestration_stack_v1.web
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
