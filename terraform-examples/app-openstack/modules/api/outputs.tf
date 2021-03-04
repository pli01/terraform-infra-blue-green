### outputs
output "status" {
  value = openstack_orchestration_stack_v1.api[*].status
  depends_on = [
    openstack_orchestration_stack_v1.api
  ]
}

output "stack_output" {
  value = openstack_orchestration_stack_v1.api[*].outputs
  depends_on = [
    openstack_orchestration_stack_v1.api
  ]
}

output "stack" {
  value = openstack_orchestration_stack_v1.api[*]
  depends_on = [
    openstack_orchestration_stack_v1.api
  ]
}
