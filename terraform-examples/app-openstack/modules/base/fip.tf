# Create floating ip
resource "openstack_networking_floatingip_v2" "web" {
  pool = var.external_network
}
resource "openstack_networking_floatingip_v2" "blue_api" {
  pool = var.external_network
}
resource "openstack_networking_floatingip_v2" "green_api" {
  pool = var.external_network
}
