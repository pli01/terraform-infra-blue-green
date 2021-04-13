# web userdata
data "cloudinit_config" "web_config" {
  gzip          = false
  base64_encode = false

  # order matter

  # cloud-init.cfg
  part {
    filename     = "cloud-init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/heat/config-scripts/cloud-init.tpl")
  }

  # config.cfg sourced in each script, and contains all needed variables
  part {
    content_type = "text/plain"
    content = templatefile("${path.module}/heat/config-scripts/config.cfg.tpl", {
      ssh_authorized_keys = jsonencode(var.ssh_authorized_keys)
      no_proxy            = var.no_proxy
    })
  }

  part {
    content_type = "text/plain"
    content      = file("${path.module}/heat/config-scripts/worker_postconf.sh")
  }

  part {
    content_type = "text/plain"
    content      = file("${path.module}/heat/config-scripts/finish_postinstall.sh")
  }
}

# api userdata
data "cloudinit_config" "api_config" {
  gzip          = false
  base64_encode = false

  # cloud-init.cfg
  part {
    filename     = "cloud-init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/heat/config-scripts/cloud-init.tpl")
  }

  # config.cfg sourced in each script, and contains all needed variables
  part {
    content_type = "text/plain"
    content = templatefile("${path.module}/heat/config-scripts/config.cfg.tpl", {
      ssh_authorized_keys = jsonencode(var.ssh_authorized_keys)
      no_proxy            = var.no_proxy
    })
  }

  part {
    content_type = "text/plain"
    content      = file("${path.module}/heat/config-scripts/worker_api_postconf.sh")
  }

  part {
    content_type = "text/plain"
    content      = file("${path.module}/heat/config-scripts/finish_postinstall.sh")
  }
}
