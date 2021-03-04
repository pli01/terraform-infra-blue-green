terraform {
  required_version = ">= 0.13"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
  backend "swift" {
    container         = "terraform-state"
    archive_container = "terraform-state-archive"
  }
}
provider "openstack" {}
