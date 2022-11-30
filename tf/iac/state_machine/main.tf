#Zachary Job
#11/13/2022
#main.tf
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Step Function and dependencies
#Manage central Security Hub/Guard Duty

#TODO
#Discuss and decide who owns roles
#
##S T A R T##########################################
resource "aws_iam_role" "temp_demo_master" {
  name = "central_security_temp_demo"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CentralSecuritySfnTempDemoMaster"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Sid    = "CentralSecuritySfnAllowAssume"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::${var.master_account}:role/basic_lambda"
        }
      }
    ]
  })
# Boto, I've a feeling we're not in KloudFormation anymore. We must be over the cloud!
#  managed_policy_arns = [
#    aws_iam_policy.hub_config.arn
#  ]

  #Likely redundant
  tags = {
    Name = "central_security_temp_demo"
  }
}

resource "aws_iam_policy" "hub_config" {
  name        = "central_security_hub_config"
  path        = "/"
  description = "For SFN configuration of central security"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CentralSecuritySfnHubConfig" 
        Effect   = "Allow"
        Action = [
          "securityhub:UpdateStandardsControl",
        ]
        Resource = "${var.central_hub_arn}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "assume_to_test" {
  role       = aws_iam_role.temp_demo_master.name
  policy_arn = aws_iam_policy.boto3_assume.arn
}

resource "aws_iam_role_policy_attachment" "temp_to_config" {
  role       = aws_iam_role.temp_demo_master.name
  policy_arn = aws_iam_policy.hub_config.arn
}
##E N D##############################################

#TODO, temp moving of lambda deploy into IAC
#
##S T A R T##########################################
#data "aws_lambda_function" "central_security_sfn_entry" {
#  function_name = "central_security_sfn_entry"
#}
#
#data "aws_lambda_function" "central_security_sfn_baseline" {
#  function_name = "central_security_sfn_baseline"
#}
#
#data "aws_lambda_function" "central_security_sfn_update" {
#  function_name = "central_security_sfn_update"
#}
#
#data "aws_lambda_function" "central_security_sfn_healthcheck" {
#  function_name = "central_security_sfn_healthcheck"
#}

data "aws_ecr_repository" "central_security_sfn_entry" {
  name = "central_security_sfn_entry"
}

data "aws_ecr_repository" "central_security_sfn_baseline" {
  name = "central_security_sfn_baseline"
}

data "aws_ecr_repository" "central_security_sfn_update" {
  name = "central_security_sfn_update"
}

data "aws_ecr_repository" "central_security_sfn_healthcheck" {
  name = "central_security_sfn_healthcheck"
}

data "aws_ecr_image" "central_security_sfn_entry" {
  repository_name = "central_security_sfn_entry"
  image_tag       = "latest"
}

data "aws_ecr_image" "central_security_sfn_baseline" {
  repository_name = "central_security_sfn_baseline"
  image_tag       = "latest"
}

data "aws_ecr_image" "central_security_sfn_update" {
  repository_name = "central_security_sfn_update"
  image_tag       = "latest"
}

data "aws_ecr_image" "central_security_sfn_healthcheck" {
  repository_name = "central_security_sfn_healthcheck"
  image_tag       = "latest"
}

resource "aws_iam_role" "basic_lambda" {
  name = "basic_lambda"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CentralSecurityLambdaPermissions",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "boto3_assume" {
  name        = "central_security_boto3_assume"
  path        = "/"
  description = "For SFN, assuming account roles"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # TODO restrict!!!
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CentralSecuritySfnAssumeRole" 
        Effect   = "Allow"
        Action = [
          "sts:AssumeRole",
        ]
        Resource = "arn:aws:iam::*:role/central_security_temp_demo"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambdaexec_to_basic" {
  role       = aws_iam_role.basic_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "assume_to_basic" {
  role       = aws_iam_role.basic_lambda.name
  policy_arn = aws_iam_policy.boto3_assume.arn
}

resource "aws_lambda_function" "central_security_sfn_entry" {
  function_name = "central_security_sfn_entry"

  package_type = "Image"
  image_uri = "${data.aws_ecr_repository.central_security_sfn_entry.repository_url}@${data.aws_ecr_image.central_security_sfn_entry.id}" 
  role = aws_iam_role.basic_lambda.arn
  timeout = 900
}

resource "aws_lambda_function" "central_security_sfn_baseline" {
  function_name = "central_security_sfn_baseline"

  package_type = "Image"
  image_uri = "${data.aws_ecr_repository.central_security_sfn_baseline.repository_url}@${data.aws_ecr_image.central_security_sfn_baseline.id}" 
  role = aws_iam_role.basic_lambda.arn
  timeout = 900
}

resource "aws_lambda_function" "central_security_sfn_update" {
  function_name = "central_security_sfn_update"

  package_type = "Image"
  image_uri = "${data.aws_ecr_repository.central_security_sfn_update.repository_url}@${data.aws_ecr_image.central_security_sfn_update.id}" 
  role = aws_iam_role.basic_lambda.arn
  timeout = 900
}

resource "aws_lambda_function" "central_security_sfn_healthcheck" {
  function_name = "central_security_sfn_healthcheck"

  package_type = "Image"
  image_uri = "${data.aws_ecr_repository.central_security_sfn_healthcheck.repository_url}@${data.aws_ecr_image.central_security_sfn_healthcheck.id}" 
  role = aws_iam_role.basic_lambda.arn 
  timeout = 900
}

##E N D##############################################

resource "aws_iam_role" "launch_and_assume" {
  name = "test_demo_master_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CentralSecuritySfnLaunchAndAssume"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]
  })
# Boto, I've a feeling we're not in KloudFormation anymore. We must be over the cloud!
#  managed_policy_arns = [
#    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
#    aws_iam_policy.assume_role.arn
#  ]

  #Likely redundant
  tags = {
    Name = "test_demo_master_role"
  }
}

resource "aws_iam_policy" "assume_role" {
  name        = "central_security_assume_role"
  path        = "/"
  description = "For SFN configuration of central security"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CentralSecuritySfnAssumeRole" 
        Effect   = "Allow"
        Action = [
          "sts:AssumeRole",
        ]
        Resource = "arn:aws:iam::*:role/central_security_temp_demo"
      },
      {
        Sid = "CentralSecuritySfnInvokeLambda" 
        Effect   = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = "arn:aws:lambda:${var.master_region}:${var.master_account}:function:central_security_sfn_*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "launch_to_assume" {
  role       = aws_iam_role.launch_and_assume.name
  policy_arn = aws_iam_policy.assume_role.arn
}

resource "aws_iam_role_policy_attachment" "launch_to_aws_lambdabasicexec" {
  role       = aws_iam_role.launch_and_assume.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Per demo minimalism comments
#
#TODO: Update post discussion on who owns IAM Role
#master and managed accounts currently hard coded
#
#DDB not yet used to manage statefulness
#Must set result_entry iterable in Entry/Baseline
#
##S T A R T##########################################
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sfn_state_machine"
  role_arn = aws_iam_role.launch_and_assume.arn

  definition = <<EOF
  {
    "Comment": "Security Hub & GuardDuty Centralized State Machine, pre DDB statefulness",
    "StartAt": "Entry",
    "States": {
      "Entry": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.central_security_sfn_entry.arn}",
        "Parameters": {
          "parameters": {
            "master_region": "${var.master_region}",
            "temp_region_selection": [
              "${local.temp_regions}"
            ],
            "master_accounts": {
              "${var.temp_demo_account}": "${aws_iam_role.temp_demo_master.arn}"
            },
            "child_accounts": {
            },
            "managed_standards_disable": {
              "fsbp": {
                "version": "${var.fsbp_version}",
                "arn_name": "aws-foundational-security-best-practices",
                "controls": {
                  ${var.fsbp_controls_disable}
                }
              },
              "cis": {
                "version": "${var.cis_version}",
                "arn_name": "cis-aws-foundations-benchmark",
                "controls": {
                  ${var.cis_controls_disable}
                }
              }
            },
            "custom_standards_enable": {
            }
          }
        },
        "ResultPath": "$.result_entry",
        "Next": "EntryBranch"
      },
      "EntryBranch": {
        "Type": "Parallel",
        "Branches": [
          {
            "StartAt": "Baseline",
            "States": {
              "Baseline": {
                "Type": "Task",
                "Resource": "${aws_lambda_function.central_security_sfn_baseline.arn}",
                "ResultPath": "$.result_entry",
                "Next": "ConfigNew"
              },
              "ConfigNew": {
                "Type": "Map",
                "ItemsPath": "$.result_entry.iterable",
                "Parameters": {
                  "result_config.$": "$$.Map.Item.Value",
                  "result_entry.$": "$.result_entry"
                },
                "MaxConcurrency": 0,
                "Iterator": {
                  "StartAt": "UpdateNew",
                  "States": {
                    "UpdateNew": {
                      "Type": "Task",
                      "Resource": "${aws_lambda_function.central_security_sfn_update.arn}",
                      "End": true
                    }
                  }
                },
                "End": true
              }
            }
          },
          {
            "StartAt": "ConfigManaged",
            "States": {
              "ConfigManaged": {
                "Type": "Map",
                "ItemsPath": "$.result_entry.iterable",
                "Parameters": {
                  "result_config.$": "$$.Map.Item.Value",
                  "result_entry.$": "$.result_entry"
                },
                "MaxConcurrency": 0,
                "Iterator": {
                  "StartAt": "UpdateManaged",
                  "States": {
                    "UpdateManaged": {
                      "Type": "Task",
                      "Resource": "${aws_lambda_function.central_security_sfn_update.arn}",
                      "End": true
                    }
                  }
                },
                "End": true
              }
            }
          }
        ],
        "ResultPath": "$.result_final",
        "Next": "HealthCheck"
      },
      "HealthCheck": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.central_security_sfn_healthcheck.arn}",
        "End": true
      }
    }
  }
  EOF
}
##E N D##############################################
