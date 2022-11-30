#Zachary Job
#11/13/2022
#variables.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#GuardDuty variables 
#Deploy centrally

#variable "dynamicsomething" {
#	type = object
#}

variable "master_region" {
	type = string
}

variable "master_account" {
  type = string
}

variable "master_organization_ok" {
  type = bool
  default = true
}

#locals {
#  port_count = length(var.ports_in)
#  container_ids = [for i in random_string.junk_string: join("_", [replace(var.image_name_in,":","_"), i.result])]
#}
