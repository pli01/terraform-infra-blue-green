module "blue_api" {
  source          = "./modules/api"
  color        = "blue"
  prefix_name  = "api"
  maxcount     = var.blue_api_count
  fip             = openstack_networking_floatingip_v2.blue_api.id
  network         = openstack_networking_network_v2.generic.id
  subnet          = openstack_networking_subnet_v2.http.id
  source_volid    = openstack_blockstorage_volume_v2.root_volume.id
  security_group  = openstack_networking_secgroup_v2.api_secgroup_1.id
  vol_type        = var.vol_type
  flavor          = var.flavor
  image           = var.image
  key_name        = var.key_name
  no_proxy        = var.no_proxy
  ssh_access_cidr = var.ssh_access_cidr
}
module "green_api" {
  source          = "./modules/api"
  color        = "green"
  prefix_name  = "api"
  maxcount     = (local.is_blue ? 0 : var.green_api_count)
  fip             = openstack_networking_floatingip_v2.green_api.id
  network         = openstack_networking_network_v2.generic.id
  subnet          = openstack_networking_subnet_v2.http.id
  source_volid    = openstack_blockstorage_volume_v2.root_volume.id
  security_group  = openstack_networking_secgroup_v2.api_secgroup_1.id
  vol_type        = var.vol_type
  flavor          = var.flavor
  image           = var.image
  key_name        = var.key_name
  no_proxy        = var.no_proxy
  ssh_access_cidr = var.ssh_access_cidr
}
