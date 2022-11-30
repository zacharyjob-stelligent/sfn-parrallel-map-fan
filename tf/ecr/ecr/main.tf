#Zachary Job
#11/13/2022
#main.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Elastic Container Registry and dependencies
#To service Centralized Security State Machine

resource "aws_ecr_repository" "central_security_sfn_entry" {
  name                 = "central_security_sfn_entry"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "central_security_sfn_baseline" {
  name                 = "central_security_sfn_baseline"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "central_security_sfn_update" {
  name                 = "central_security_sfn_update"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "central_security_sfn_healthcheck" {
  name                 = "central_security_sfn_healthcheck"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}
