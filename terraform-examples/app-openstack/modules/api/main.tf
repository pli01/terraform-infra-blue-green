#### Heat CONFIGURATION ####
# create heat stack
resource "openstack_orchestration_stack_v1" "api" {
  count   = var.maxcount
  name    = format("%s-%s-%s", var.color, var.prefix_name, count.index + 1)
  # override heat parameters
  parameters = {
    floating_ip_id  = var.fip
    security_group  = var.security_group
    worker_network  = var.network
    worker_subnet   = var.subnet
    source_volid    = var.source_volid
    worker_vol_type = var.vol_type
    worker_flavor   = var.flavor
    key_name        = var.key_name
    affinity_group  = var.affinity_group
    user_data       = var.user_data
  }
  # override heat parameters with param files
  environment_opts = {
    Bin = "\n"
    #Bin = file("${path.module}/../../heat/env.yaml")
  }
  # define heat file
  template_opts = {
    #Bin = file("${path.module}/../../heat/api-rg.yaml")
    Bin = file("${path.module}/../../heat/api.yaml")
  }
  disable_rollback = true
  #  disable_rollback = false
  timeout = 30
}

