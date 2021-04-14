output "blue_api_id" {
  value = openstack_networking_floatingip_v2.blue_api.id
}
output "green_api_id" {
  value = openstack_networking_floatingip_v2.green_api.id
}
output "web_id" {
  value = openstack_networking_floatingip_v2.web.id
}
output "web_address" {
  value = openstack_networking_floatingip_v2.web.address
}

output "network_id" {
  value = openstack_networking_network_v2.generic.id
}
output "subnet_id" {
  value = openstack_networking_subnet_v2.http.id
}
output "root_volume_id" {
  value = openstack_blockstorage_volume_v2.root_volume.id
}
output "api_secgroup_id" {
  value = openstack_networking_secgroup_v2.api_secgroup_1.id
}
output "web_secgroup_id" {
  value = openstack_networking_secgroup_v2.web_secgroup_1.id
}
output "servergroup_id" {
  value = openstack_compute_servergroup_v2.sg.id
}
