#Zachary Job
#11/13/2022
#
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#

variable "dependency_string" {
  type = string
  default = "default"
}

variable "image_in" {
#  type = object
}

variable "image_name_in" {
#  type = object
}

variable "ports_in" {
  type = list
  default = [22,6022]

  validation {
    condition = length(var.ports_in) >= 1
    error_message = "Error: ports_in empty!"
  }
  validation {
    condition = max(var.ports_in...) < 65535 && min(var.ports_in...) > 0
    error_message = "Error: Invalid port in ports_in!"
  }
}

variable "volumes_in" {
  type = list
  default = ["1"]

  validation {
    condition = length(var.volumes_in) >= 1
    error_message = "Error: not enough volumes!"
  }
}

locals {
  port_count = length(var.ports_in)
  container_ids = [for i in random_string.junk_string: join("_", [replace(var.image_name_in,":","_"), i.result])]
}
