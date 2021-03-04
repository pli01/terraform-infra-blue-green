locals {
  is_blue            = (var.color == "blue" ? true : false)
  stack_status        = (local.is_blue ? module.blue_api.status : module.green_api.status )
  #active_server_name = (local.is_blue ? [openstack_networking_floatingip_v2.blue_api.fixed_ip] : [openstack_networking_floatingip_v2.green_api.fixed_ip])
  active_server_name = (local.is_blue ? [openstack_networking_floatingip_v2.blue_api.address] : [openstack_networking_floatingip_v2.green_api.address])
#  active_server_name = (local.is_blue ? module.blue_api.stack_output : module.green_api.stack_output)
#  active_server_name = (local.is_blue ? module.blue_api[*].name : module.green_api[*].name)
}

module "web" {
  source          = "./modules/web"
  fip             = openstack_networking_floatingip_v2.web.id
  network         = openstack_networking_network_v2.generic.id
  subnet          = openstack_networking_subnet_v2.http.id
  source_volid    = openstack_blockstorage_volume_v2.root_volume.id
  security_group  = openstack_networking_secgroup_v2.web_secgroup_1.id
  vol_type        = var.vol_type
  flavor          = var.flavor
  image           = var.image
  key_name        = var.key_name
  no_proxy        = var.no_proxy
  ssh_access_cidr = var.ssh_access_cidr
  color           = var.color
  #api_server      = "server 127.0.0.1:9000;"
  api_server      = format("%s", join(" ", formatlist("%s %s:%s;", "server", flatten(local.active_server_name), var.api_port)))
  depends_on = [
      local.stack_status
  ]

}
