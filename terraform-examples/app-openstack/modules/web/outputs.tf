### outputs
output "stack_output" {
  value = openstack_orchestration_stack_v1.web.outputs
  depends_on = [
    openstack_orchestration_stack_v1.web
  ]
}

output "id" {
  value = openstack_orchestration_stack_v1.web[*].outputs[0]["output_value"]
  depends_on = [
    openstack_orchestration_stack_v1.web
  ]
}

output "private_ip" {
  value = openstack_orchestration_stack_v1.web[*].outputs[1]["output_value"]
  depends_on = [
    openstack_orchestration_stack_v1.web
  ]
}


