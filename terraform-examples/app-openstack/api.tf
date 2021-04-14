module "blue_api" {
  source         = "./modules/api"
  color          = "blue"
  prefix_name    = "api"
  maxcount       = var.blue_api_count
  fip            = module.base.blue_api_id
  network        = module.base.network_id
  subnet         = module.base.subnet_id
  source_volid   = module.base.root_volume_id
  security_group = module.base.api_secgroup_id
  affinity_group = module.base.servergroup_id
  vol_type       = var.vol_type
  flavor         = var.flavor
  image          = var.image
  key_name       = var.key_name
  no_proxy          = var.no_proxy
  ssh_authorized_keys          = var.ssh_authorized_keys
  depends_on = [
    module.base
  ]
}

module "green_api" {
  source         = "./modules/api"
  color          = "green"
  prefix_name    = "api"
  maxcount       = (local.is_blue ? 0 : var.green_api_count)
  fip            = module.base.green_api_id
  network        = module.base.network_id
  subnet         = module.base.subnet_id
  source_volid   = module.base.root_volume_id
  security_group = module.base.api_secgroup_id
  affinity_group = module.base.servergroup_id
  vol_type       = var.vol_type
  flavor         = var.flavor
  image          = var.image
  key_name       = var.key_name
  no_proxy          = var.no_proxy
  ssh_authorized_keys          = var.ssh_authorized_keys
  depends_on = [
    module.base
  ]
}
