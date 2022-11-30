#Zachary Job
#11/13/2022
#
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.23.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#Actions configures local docker for ref 
provider "docker" {}

provider "aws" {
	shared_credentials_files = var.credential_store 
	region = var.master_region

  default_tags {
    tags = {
      App = var.app_name 
      Source = "Terraform"
    }
  }
}
