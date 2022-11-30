#Zachary Job
#11/13/2022
#variables.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Variable prototypes
#For copying during the build process as I am
#not using Cloud or better

variable "master_region" {
	type = string
}

variable "app_name" {
  type = string
}

variable "credential_store" {
	type = list 
}

#TODO single account demo
#Up for discussion who/what is provisioning roles
#GOTO iac -> state_machine -> main.tf for temp definitions
#
##S T A R T##########################################
#Format:
#"<Account Number>": "<IAM Role>"
#variable "master_accounts" {
#	type = string
#
#	default = <<EOF
#  EOF
#}

#Format:
#"<Account Number>": "<IAM Role>"
#variable "managed_accounts" {
#	type = string
#
#	default = <<EOF
#  EOF
#}

variable "temp_demo_account" {
  type = string
}

variable "temp_region_selection" {
  type = list
}
##E N D##############################################

variable "fsbp_version" {
  type = string
}

variable "cis_version" {
  type = string
}

#Format:
#"<Control>": "<bool, includes master region>"
variable "fsbp_1-0-0_controls_disable" {
	type = string
}

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
variable "cis_1-2-0_controls_disable" {
	type = string
}

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
variable "cis_1-4-0_controls_disable" {
	type = string
}

#format:
#"<Custom Standard>"
#   "<Version>"
#   "<Bucket>": "string, S3 Bucket ARN"
#   "<Controls>":
#       "<Control>": "<bool, includes master account>"
variable "custom_controls_enable" {
	type = string
}
