export AWS_PROFILE=ce-iso-sandbox

cd ../../tf/iac
terraform plan -input=false -out=iac_temp.plan 
terraform apply -auto-approve iac_temp.plan 
