# Create floating ip
resource "openstack_networking_floatingip_v2" "web" {
  pool = var.external_network
}

