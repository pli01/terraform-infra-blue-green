app-openstack
* decte/retry when stack failed
* use Resource Group (fix count instance) or AutoScaling Group (dynamic count instances) -> extract fixed private ip

+ stack output tolist extract format: 
  FIXED: value = openstack_orchestration_stack_v1.api[*].outputs[1]["output_value"]

```
web_stack_output = tolist([
  {
    "description" = "worker id"
    "output_key" = "worker_id"
    "output_value" = "b32a8e28-d168-44c7-8e5c-b3a3eb9ef75f"
  },
  {
    "description" = "worker private ip address"
    "output_key" = "worker_private_ip_address"
    "output_value" = "192.168.1.11"
  },
  {
    "description" = "worker public ip address"
    "output_key" = "worker_public_ip_address"
    "output_value" = "10.2.6.185"
  },
])

+ web stack update metadata to catch color and api_server param (old dirty fix with cron , curl metadata)
+ stack update behaviour, when volume id change du to image id change (most_recent = true...)

Terragrunt, dependency, dependencies
https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/
