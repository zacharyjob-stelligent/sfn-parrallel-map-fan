#Zachary Job
#11/13/2022
#outputs.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Portable shared outputs outside cloud
#For copying during the build process as I am
#not using Cloud or better

output "master_region" {
	value = var.master_region
}

output "credential_store" {
	value = var.credential_store
}

output "app_name" {
  value = var.app_name
}

#TODO single account demo
#Up for discussion who/what is provisioning roles
#GOTO iac -> state_machine -> main.tf for temp definitions
#
##S T A R T##########################################
#Format:
#"<Account Number>": "<IAM Role>"
#output "master_accounts" {
#	type = string
#
#	default = <<EOF
#  EOF
#}

#Format:
#"<Account Number>": "<IAM Role>"
#output "managed_accounts" {
#	type = string
#
#	default = <<EOF
#  EOF
#}

output "temp_demo_account" {
  value = var.temp_demo_account
}

output "temp_region_selection" {
  value = var.temp_region_selection
}
##E N D##############################################

output "fsbp_version" {
  value = var.fsbp_version
}

output "cis_version" {
  value = var.cis_version
}

#Format:
#"<Control>": "<bool, includes master region>"
output "fsbp_1-0-0_controls_disable" {
	value = var.fsbp_1-0-0_controls_disable
}

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
output "cis_1-2-0_controls_disable" {
	value = var.cis_1-2-0_controls_disable
}

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
output "cis_1-4-0_controls_disable" {
	value = var.cis_1-4-0_controls_disable
}

#format:
#"<Custom Standard>"
#   "<Version>"
#   "<Bucket>": "string, S3 Bucket ARN"
#   "<Controls>":
#       "<Control>": "<bool, includes master account>"
output "custom_controls_enable" {
	value = var.custom_controls_enable
}
