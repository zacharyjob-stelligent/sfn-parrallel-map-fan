terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.23.0"
    },
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#Actions configures local docker for ref 
provider "docker" {}

provider "aws" {
	shared_credentials_file = var.credential_store 
	region = var.master_region
}
