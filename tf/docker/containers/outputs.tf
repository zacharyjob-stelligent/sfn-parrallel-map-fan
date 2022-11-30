#Zachary Job
#11/13/2022
#
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#

output "instances" {
  value = {
    for i in docker_container.docker: i.name => join(":", [i.ip_address], i.ports[*]["internal"])
  }
}
