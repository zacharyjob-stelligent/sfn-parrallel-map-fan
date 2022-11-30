#Zachary Job
#11/13/2022
#outputs.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Security Hub outputs 

#Temporarily disabled for demo state 
#
#output "somethingdisabledfornow" {
#  value = sometype.somename
#}

output "hub_arn" {
  value = "arn:aws:securityhub:*:${aws_securityhub_account.master.id}:hub/default" 
}
