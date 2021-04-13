#### Heat CONFIGURATION ####
# create heat stack
resource "openstack_orchestration_stack_v1" "web" {
  name = "web"
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
    color           = var.color
    api_server      = var.api_server
    user_data       = var.user_data
  }
  # override heat parameters with param files
  environment_opts = {
    Bin = "\n"
    # Bin = file("heat/web-param.yaml")
  }
  # define heat file
  template_opts = {
    Bin = file("${path.module}/../../heat/web.yaml")
    # Bin = file("${path.root}/heat/web.yaml")
    #Bin = file("${path.cwd}/heat/web.yaml")
  }
  disable_rollback = true
  #  disable_rollback = false
  timeout = 30
}

