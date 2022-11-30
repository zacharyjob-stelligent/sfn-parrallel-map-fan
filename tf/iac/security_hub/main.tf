#Zachary Job
#11/13/2022
#main.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#SecurityHub and dependencies
#Deploy centrally

resource "aws_securityhub_account" "master" {}

resource "aws_securityhub_finding_aggregator" "all_regions" {
	#Single account tests
#  linking_mode = "ALL_REGIONS"
  linking_mode      = "SPECIFIED_REGIONS"
  specified_regions = local.region_minus_master 

  depends_on = [aws_securityhub_account.master]
}

#Explicit
resource "aws_securityhub_standards_subscription" "fsbp" {
  depends_on    = [aws_securityhub_account.master]

#  standards_arn = "arn:aws:securityhub:${var.master_region}::standards/aws-foundational-security-best-practices/v/${var.fsbp_version}"
  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/${var.fsbp_version}"
}

#Explicit
resource "aws_securityhub_standards_subscription" "cis" {
  depends_on    = [aws_securityhub_account.master]

  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/${var.cis_version}"
}

#Temporarily disabled for demo state 
#
#resource "aws_securityhub_organization_admin_account" "" {
#  depends_on = [var.master_organization_ok]
#
#  admin_account_id = var.master_account
#}

#Temporarily disabled for demo state 
#
#resource "aws_securityhub_organization_configuration" "example" {
#  auto_enable = true
#}
