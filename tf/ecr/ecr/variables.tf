#Zachary Job
#11/13/2022
#main.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#SecurityHub variables 
#Deploy centrally

variable "master_region" {
	type = string
}

variable "app_name" {
  type = string
}

variable "credential_store" {
	type = list
}
