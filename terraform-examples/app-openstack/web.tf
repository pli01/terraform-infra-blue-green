module "web" {
  source          = "./modules/web"
  fip             = openstack_networking_floatingip_v2.web.id
  network         = openstack_networking_network_v2.generic.id
  subnet          = openstack_networking_subnet_v2.http.id
  source_volid    = openstack_blockstorage_volume_v2.root_volume.id
  vol_type        = var.vol_type
  flavor          = var.flavor
  image           = var.image
  key_name        = var.key_name
  no_proxy        = var.no_proxy
  ssh_access_cidr = var.ssh_access_cidr
}
