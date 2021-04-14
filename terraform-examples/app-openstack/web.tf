locals {
  is_blue          = (var.color == "blue" ? true : false)
  stack_status     = (local.is_blue ? module.blue_api.status : module.green_api.status)
  active_server_ip = (local.is_blue ? flatten(module.blue_api[*].private_ip) : flatten(module.green_api[*].private_ip))
  # active_server_ip = (local.is_blue ? [openstack_networking_floatingip_v2.blue_api.address] : [openstack_networking_floatingip_v2.green_api.address])
  # active_server_ip = (local.is_blue ? [openstack_networking_floatingip_v2.blue_api.fixed_ip] : [openstack_networking_floatingip_v2.green_api.fixed_ip])
  # active_server_ip = (local.is_blue ? module.blue_api.stack_output : module.green_api.stack_output)
  # active_server_ip = (local.is_blue ? module.blue_api[*].name : module.green_api[*].name)
}

module "web" {
  source              = "./modules/web"
  fip                 = module.base.web_id
  network             = module.base.network_id
  subnet              = module.base.subnet_id
  source_volid        = module.base.root_volume_id
  security_group      = module.base.web_secgroup_id
  vol_type            = var.vol_type
  flavor              = var.flavor
  image               = var.image
  key_name            = var.key_name
  color               = var.color
  no_proxy            = var.no_proxy
  ssh_authorized_keys = var.ssh_authorized_keys
  #api_server      = "server 127.0.0.1:9000;"
  api_server = format("%s", join(" ", formatlist("%s %s:%s;", "server", flatten(local.active_server_ip), var.api_port)))
  depends_on = [
    local.stack_status,
    module.base
  ]
}
