### outputs
output "stack_output" {
  value = openstack_orchestration_stack_v1.api[*].outputs
  depends_on = [
    openstack_orchestration_stack_v1.api
  ]
}
