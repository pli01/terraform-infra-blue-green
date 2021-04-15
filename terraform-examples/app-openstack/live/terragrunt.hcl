#
# provider openstack
#
generate "provider.tf" {
 path = "provider.tf"
 if_exists = "overwrite"
 contents = <<EOF
provider "openstack" {}
EOF
}

generate "backend" {
 path = "backend.tf"
 if_exists = "overwrite"
 contents = <<EOF
terraform {
  backend "swift" {}
}
EOF
}
#
# backend swift
#
remote_state {
  backend = "swift"
  config = {
    container         = "terraform-state"
    archive_container = "terraform-state-archive"
  }
}

terraform {
 extra_arguments "conditionnal_vars" {
  commands = [
    "apply",
    "plan",
    "import",
    "push",
    "refresh"
  ]

  required_var_files  = [
   "${get_parent_terragrunt_dir()}/common.tfvars"
   #"${get_terragrunt_dir()}/${get_env("TF_VAR_env","dev")}.tfvars"
  ]
  optional_var_files   = [
   #"${get_parent_terragrunt_dir()}/${get_env("TF_VAR_env","dev")}.tfvars",
   "${get_terragrunt_dir()}/${get_env("TF_VAR_env","dev")}.tfvars"
  ]
 }
}
