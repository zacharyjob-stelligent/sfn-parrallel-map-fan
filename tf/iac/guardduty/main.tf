#Zachary Job
#11/13/2022
#main.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#GuardDuty and dependencies
#Deploy centrally

#Temporarily disabled for demo state 
#
#resource "aws_organizations_organization" "isolated" {
#  aws_service_access_principals = [
#		"guardduty.amazonaws.com",
#		"cloudtrail.amazonaws.com",
#		"config.amazonaws.com",
#		"securityhub.amazonaws.com"]
#  feature_set                   = "ALL"
#}

resource "aws_guardduty_detector" "master" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = false
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }
}

#Temporarily disabled for demo state 
#
#resource "aws_guardduty_organization_admin_account" "isolated" {
#  depends_on = [aws_organizations_organization.isolated]
#
#  admin_account_id = var.master_account
#}
