#locals {
#  # Automatically load environment-level variables
#  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
#}
#inputs = merge(
#  local.environment_vars.locals
#)
#
# override provider.tf
#
generate "provider.tf" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "openstack" {}
EOF
}
#
# override backend.tf
#
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
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
      "destroy",
      "import",
      "push",
      "refresh"
    ]

    required_var_files = [
      #"${get_parent_terragrunt_dir()}/common.tfvars",
      "${find_in_parent_folders("${get_env("TF_VAR_env")}.tfvars")}"
      #"${get_terragrunt_dir()}/${get_env("TF_VAR_env")}.tfvars"
    ]
    optional_var_files = [
      #"${get_parent_terragrunt_dir()}/${get_env("TF_VAR_env")}.tfvars",
      #"${get_terragrunt_dir()}/${get_env("TF_VAR_env")}.tfvars"
    ]
  }

  after_hook "terraform_lock" {
    commands = get_terraform_commands_that_need_locking()
    #execute  = ["rm", "-f", "${get_terragrunt_dir()}/.terraform.lock.hcl"]
    execute = ["echo", "# after hook"]
  }

}
