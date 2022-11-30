#Zachary Job
#11/13/2022
#outputs.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#GuardDuty outputs 

#Temporarily disabled for demo state 
#
#output "organization" {
#  value = aws_organizations_organization.isolated
#}

output "master_organization_ok" {
#  depends_on = [aws_organizations_organization.isolated]
  value = true
}
