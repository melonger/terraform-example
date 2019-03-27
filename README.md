# Terraform

## How Terraform Works

### Validate
Used to parse code without having to pre-compile using plan/apply. It will parse all of the .tf files and verify and validate the syntax, generating errors to correct.

### Plan
The process of seeing what changes will be applied to your environment. Terraform will go through a compilation process, looking for state files and previously ran content. If nothing exists, it will be listed as new changes. Whereas anything already created will list the changes that will apply.

#### Plan Out - Serializing your deployment process
By adding the `-out=path` parameter to your terraform plan, you can gain the capability of an apply serialization. This plan can then be used with terraform apply to be certain that only the changes shown in this plan are applied

This will cause the tool to serialize the current state as well as the planned changes to an output file. By doing so, it will leverage the output plan already created to push the change, rather than replan and attempt the change.

### Apply
Running an apply will run the plan, and applying the changes.

### Destroy
Destroys all resources based on the local/remote state file

#### `Taint` your infrastructure
manually marks a Terraform-managed resource as tainted, forcing it to be destroyed and recreated on the next apply.

Can be used when you want to force startup scripts to be run, or to force a box to be destroyed and recreated

## Variables
Running your `terraform plan`, `apply`, `destroy` with the `--var-file=path/to/terraform.tfvars`, or by default from a terraform.tfvars file in the root of the resource.

Good practice is to create your variables place holders in a `variables.tf` file, and then create a `*.tfvars` file with all the relevant data.

## Credentials
Credentials for cloud platforms can be used as hardcoded variables, but is highly suggested to use the environment variables to store the keys. Another method is to use a credentials file and importing them via --var-file.

In either case, keeping the credentials and configuration variables separate from the framework code is best practice, and also adheres to 12 factor application development.
