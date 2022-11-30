#Zachary Job
#11/13/2022
#terraform.tfvars
#
#Note currently following 'brutally' minimal
#guidance. Single account
#
#Variable definitions
#For copying during the build process as I am
#not using Cloud or better

master_region = "us-east-1"
app_name = "CentralSecuritySFNConfigurator"

credential_store = [
  "~/.aws/credentials"
]

#TODO single account demo
#Up for discussion who/what is provisioning roles
#GOTO iac -> state_machine -> main.tf for temp definitions
#
##S T A R T##########################################
#Format:
#"<Account Number>": "<IAM Role>"
#	master_accounts = <<EOF
#  EOF

#Format:
#"<Account Number>": "<IAM Role>"
#	managed_accounts = <<EOF
#  EOF

temp_demo_account = "302068939047"

#Just to sample potential feature updates,
#demonstrated how this could prop to the lambda
#but this is disabled for production. Intent would
#be to upgrade for handling disjoint hubs
temp_region_selection = [
  "us-east-1",
  "us-east-2"
]
##E N D##############################################

fsbp_version = "1.0.0"

cis_version = "1.2.0"

#Format:
#"<Control>": "<bool, includes master region>"
fsbp_1-0-0_controls_disable = <<EOF
    "Config.1": "true",
    "IAM.1": "false",
    "IAM.2": "false",
    "IAM.3": "false",
    "IAM.4": "false",
    "IAM.5": "false",
    "IAM.6": "false",
    "IAM.7": "false",
    "IAM.8": "false",
    "IAM.21": "false",
    "KMS.1": "false",
    "KMS.2": "false"
  EOF

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
cis_1-2-0_controls_disable = <<EOF
    "2.7": "false",
    "1.2": "false",
    "1.3": "false",
    "1.4": "false",
    "1.5": "false",
    "1.6": "false",
    "1.7": "false",
    "1.8": "false",
    "1.9": "false",
    "1.10": "false",
    "1.11": "false",
    "1.12": "false",
    "1.13": "false",
    "1.14": "false",
    "1.16": "false",
    "1.20": "false",
    "1.22": "false",
    "2.5": "true",
    "1.1": "true",
    "3.1": "true",
    "3.2": "true",
    "3.3": "true",
    "3.4": "true",
    "3.5": "true",
    "3.6": "true",
    "3.7": "true",
    "3.8": "true",
    "3.9": "true",
    "3.10": "true",
    "3.11": "true",
    "3.12": "true",
    "3.13": "true",
    "3.14": "true"
  EOF

#true if includes master, false if not
#format: "<Control>": "<bool, includes master region>"
cis_1-4-0_controls_disable = <<EOF
    "3.7": "false",
    "1.4": "false",
    "1.5": "false",
    "1.6": "false",
    "1.7": "false",
    "1.8": "false",
    "1.9": "false",
    "1.10": "false",
    "1.12": "false",
    "1.14": "false",
    "1.16": "false",
    "1.17": "false",
    "3.5": "true",
    "1.7": "true",
    "4.4": "true",
    "4.5": "true",
    "4.6": "true",
    "4.7": "true",
    "4.8": "true",
    "4.9": "true",
    "4.10": "true",
    "4.11": "true",
    "4.12": "true",
    "4.13": "true",
    "4.14", "true"
  EOF

#format:
#"<Custom Standard>"
#   "<Version>"
#   "<Bucket>": "string, S3 Bucket ARN"
#   "<Controls>":
#       "<Control>": "<bool, includes master account>"
custom_controls_enable = <<EOF
  EOF
