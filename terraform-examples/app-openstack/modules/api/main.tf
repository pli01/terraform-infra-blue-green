#### Heat CONFIGURATION ####
# create heat stack
resource "openstack_orchestration_stack_v1" "api" {
  count   = var.maxcount
  name    = format("%s-%s-%s", var.color, var.prefix_name, count.index + 1)
  # override heat parameters
  parameters = {
    worker_network  = var.network
    worker_subnet   = var.subnet
    source_volid    = var.source_volid
    worker_vol_type = var.vol_type
    worker_flavor   = var.flavor
    worker_image    = var.image
    key_name        = var.key_name
    no_proxy        = var.no_proxy
    ssh_access_cidr = var.ssh_access_cidr
  }
  # override heat parameters with param files
  environment_opts = {
    Bin = "\n"
    # Bin = file("heat/api-param.yml")
  }
  # define heat file
  template_opts = {
    Bin = file("${path.module}/../../heat/api.yml")
  }
  disable_rollback = true
  #  disable_rollback = false
  timeout = 30
}

