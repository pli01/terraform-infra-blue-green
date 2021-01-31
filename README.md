# terraform-infra-blue-green
terraform-infra-blue-green

## Content

* terraform cli in docker image: everything we need in one place, no matter who s running it or wher
  + Dockerfile
  + install default deb packages (python, jq, openstack-client)
  + install pip modules
  + install terraform cli in /usr/local/bin
  + install versioned terraform plugins from providers.tf in /usr/local/share/terraform/plugins

* 
