### outputs
output "stack_output" {
  value = openstack_orchestration_stack_v1.web.outputs
  depends_on = [
    openstack_orchestration_stack_v1.web
  ]
}
