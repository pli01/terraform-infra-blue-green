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

output "private_ip" {
  value = openstack_orchestration_stack_v1.api[*].outputs[1]["output_value"]
  depends_on = [
    openstack_orchestration_stack_v1.api
  ]
}

output "public_ip" {
  # value =  openstack_orchestration_stack_v1.api[*].outputs[2]["output_value"]
  value =  length(openstack_orchestration_stack_v1.api[*].outputs)
  #value =  ( length(openstack_orchestration_stack_v1.api[*].outputs) > 1 ? openstack_orchestration_stack_v1.api[*].outputs[2]["output_value"] : [] )
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
