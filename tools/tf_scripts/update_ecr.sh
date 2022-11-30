export AWS_PROFILE=ce-iso-sandbox

cd ../../tf/ecr
terraform plan -input=false -out=ecr_temp.plan 
terraform apply -auto-approve ecr_temp.plan 
