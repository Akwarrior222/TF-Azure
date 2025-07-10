locals {
  default_startup_script = templatefile("${path.module}/templates/userdata.sh", {
    ssh_port = var.ssh_port
  })

  startup_script = join("\n\n", [local.default_startup_script, var.custom_startup_script])

  instance_name = "${var.project_prefix}-${var.instance_name}"
}
