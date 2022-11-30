#Zachary Job
#11/13/2022
#
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#

# Create a container
resource "docker_container" "docker" {
  depends_on = [var.dependency_string, docker_volume.docker_volume]
  image = var.image_in
  count = local.port_count
  name  = local.container_ids[count.index] 
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
  ports {
    internal = var.ports_in[count.index]
    #external = 22
  }
  dynamic "volumes" {
    for_each = var.volumes_in
    content {
      container_path = "${path.cwd}/${local.container_ids[count.index]}_mount_${volumes.value}"
      volume_name = "${local.container_ids[count.index]}_volume_${volumes.value}" 
    }
  }
}

resource "docker_volume" "docker_volume" {
  count = local.port_count
  name = "${local.container_ids[count.index]}_volume" 
  lifecycle {
    prevent_destroy = false
  }
#  provisioner "local-exec" {
#    when = destroy
#    command = "mkdir ${path.cwd}/backups"
#    on_failure = continue
#  }
#  provisioner "local-exec" {
#    when = destroy
#    command = "sudo tar -czvf ${path.cwd}/backups/${self.name}.tar.gz ${self.mountpoint}/"
#    on_failure = continue
#  }
}
