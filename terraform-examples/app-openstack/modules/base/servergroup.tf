resource "openstack_compute_servergroup_v2" "sg" {
  name     = "my-sg"
  policies = ["anti-affinity"]
}
