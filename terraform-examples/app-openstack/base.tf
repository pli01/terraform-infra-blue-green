module "base" {
  source = "./modules/base"
  # network, fip
  external_network = var.external_network
  network_http     = var.network_http
  dns_ip           = var.dns_ip
  # security group
  ssh_access_cidr = var.ssh_access_cidr
  # root volume
  vol_type          = var.vol_type
  vol_size          = var.vol_size
  image             = var.image
  most_recent_image = var.most_recent_image
}
