# output
output "color" {
  description = "color"
  value       = var.color
}
### outputs
#output "stack_output" {
#  #  value = module.web.stack_output
#  value = openstack_orchestration_stack_v1.web.outputs
#  depends_on = [
#    # module.web
#    openstack_orchestration_stack_v1.web
#  ]
#}
