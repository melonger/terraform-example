Refer to https://github.com/terraform-providers for more providers/plugins

# To enable Debug

    $env:TF_LOG = "DEBUG"
    $env:TF_LOG_PATH = "C:/Repositories/terraform.log"

Start with the `0-setup` folder to configure client environment

    terraform get -update

Update the `backend.tf` in each instance to reflect where the state file will go.

Put variable values into `.tfvars` files in the `datafiles` directory.

Create a remote state section for each of the subsections being created (`setup`, `role`, `post-process`).

    cd 1-QA/author
    terraform init
    terraform plan --var-file=../../datafiles/qa.tfvars  ##  EXPLICITLY refer to .tfvars files
    echo "yes" | terraform apply --var-file=../../datafiles/qa.tfvars
    echo "yes" | terraform destroy --var-file=..../datafiles/qa.tfvars
