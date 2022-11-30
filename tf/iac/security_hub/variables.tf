#Zachary Job
#11/13/2022
#variables.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#SecurityHub variables 
#Deploy centrally

#variable "organization_in" {
#	type = object
#}

variable "master_region" {
	type = string
}

variable "temp_region_selection" {
  type = list
}

variable "master_account" {
  type = string
}

variable "master_organization_ok" {
  type = bool
}

variable "fsbp_version" {
	type = string
}

variable "cis_version" {
	type = string
}

locals {
  region_minus_master = [for i in var.temp_region_selection: i if i != var.master_region]
}
