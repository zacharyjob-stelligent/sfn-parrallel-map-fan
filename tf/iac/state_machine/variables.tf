#Zachary Job
#11/13/2022
#vairables.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#State Machine variables 

variable "temp_demo_account" {
	type = string
}

variable "central_hub_arn" {
	type = string
}

variable "master_account" {
	type = string
}

variable "master_region" {
	type = string
}

variable "temp_region_selection" {
  type = list
}

variable "fsbp_version" {
	type = string
}

variable "cis_version" {
	type = string
}

variable "fsbp_controls_disable" {
	type = string
}

variable "cis_controls_disable" {
	type = string
}

variable "custom_controls_enable" {
	type = string
}

#Intentional to show how multi region would reach
#source for disjoint hubs
locals {
  #  temp_regions = join("\", \"", var.temp_region_selection)
  temp_regions = var.master_region 
}
