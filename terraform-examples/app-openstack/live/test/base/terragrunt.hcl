terraform {
 source = "../../../modules//base"
}

include {
 path = find_in_parent_folders()
}

inputs = {
#  external_network = var.external_network
#  network_http     = var.network_http
#  dns_ip           = var.dns_ip
#  # security group
#  ssh_access_cidr = var.ssh_access_cidr
#  # root volume
#  vol_type          = var.vol_type
#  vol_size          = var.vol_size
#  image             = var.image
#  most_recent_image = var.most_recent_image
}
