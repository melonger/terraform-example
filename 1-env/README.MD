Notes:

backend.tf needs to point to the correct bucket
'Terraform init' must be run to initialize the back end first, then a plan, and apply can be performed

Steps:
cd author
terraform init
terraform plan --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform apply --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform destroy --var-file=../../datafiles/qa.tfvars
cd publish
terraform init
terraform plan --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform apply --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform destroy --var-file=../../datafiles/qa.tfvars
cd dispatch
terraform init
terraform plan --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform apply --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform destroy --var-file=../../datafiles/qa.tfvars
cd configure
terraform init
terraform plan --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform apply --var-file=../../datafiles/qa.tfvars
echo "yes" | terraform destroy --var-file=../../datafiles/qa.tfvars
