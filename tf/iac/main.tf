#Zachary Job
#11/13/2022
#main.tf
#
#AWS Application
#Deploys solution IaC for configuring Security Hub and GuardDuty
#for centralized governance. This includes a state machine

module "guardduty" {
  source = "./guardduty"

  master_region = var.master_region
  master_account = var.temp_demo_account
}

module "security_hub" {
	# explicit for sake of readability and docs
	depends_on = [module.guardduty]
  source = "./security_hub"

	#Temporarily disabled for demo state
	#
#	organization_in = module.guardduty.organization	
  master_region = var.master_region
  master_account = var.temp_demo_account
  master_organization_ok = module.guardduty.master_organization_ok
  temp_region_selection = var.temp_region_selection
  fsbp_version = var.fsbp_version
  cis_version = var.cis_version
}

#Temporarily disabled for demo state
#
#module "dynamo_db" {
#	# explicit for sake of readability and docs
#	depends_on = [module.security_hub]
#
#  source = "./dynamo_db"
#}

module "state_machine" {
	# explicit for sake of readability and docs
#	depends_on = [module.dynamo_db]
	depends_on = [module.security_hub]
  source = "./state_machine"

  master_account = var.temp_demo_account
  master_region = var.master_region
  temp_region_selection = var.temp_region_selection
  fsbp_version = var.fsbp_version
  cis_version = var.cis_version
  fsbp_controls_disable = var.fsbp_1-0-0_controls_disable
  cis_controls_disable = var.cis_1-2-0_controls_disable
  custom_controls_enable = var.custom_controls_enable
  central_hub_arn = module.security_hub.hub_arn
  #demo
  temp_demo_account = var.temp_demo_account
}
