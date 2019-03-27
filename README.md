Refer to https://github.com/terraform-providers for more providers/plugins

# To enable Debug
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "C:/Repositories/terraform.log"

Update the `backend.tf` in each instance to reflect where the state file is to reside
All environment variable files reside in `varfiles`
create remote state section for each of the subsections being created (setup, role, post-process)

## Setup Environment
1. `cd 0-setup`
1. `terraform init`
1. `terraform plan --var-file=../varfiles/setup.tfvars`
1. `echo "yes" | terraform apply --var-file=../varfiles/setup.tfvars`
1. `echo "yes" | terraform destroy --var-file=../varfiles/setup.tfvars`

## Setup Instance - Author
1. `cd 1-qa/author`
1. `terraform init`
1. `terraform plan --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform apply --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform destroy --var-file=..../varfiles/qa.tfvars`

## Setup Instance - Publisher
1. `cd 1-qa/publish`
1. `terraform init`
1. `terraform plan --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform apply --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform destroy --var-file=..../varfiles/qa.tfvars`

## Setup Instance - Dispatcher
1. `cd 1-qa/dispatch`
1. `terraform init`
1. `terraform plan --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform apply --var-file=../../varfiles/qa.tfvars`
1. `echo "yes" | terraform destroy --var-file=..../varfiles/qa.tfvars`
