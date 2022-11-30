#Zachary Job
#11/13/2022
#main.tf
#
#AWS ECR Repositories
#Deploys solution IaC for establishing lambda container repos 
#for a centralized state machine

module "elastic_container_repository" {
  source = "./ecr"
  master_region = var.master_region
  credential_store = var.credential_store
  app_name = var.app_name
}
