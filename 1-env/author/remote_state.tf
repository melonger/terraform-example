data "terraform_remote_state" "disp" {
  backend = "${var.backend}"
  config {
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.tags["client"]}/${var.environment}/dispatch/terraform.tfstate"
    # access_key            = "STORED IN ENV VARIABLE ARM_ACCESS_KEY"
  }
}

data "terraform_remote_state" "auth" {
  backend = "${var.backend}"
  config {
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.tags["client"]}/${var.environment}/author/terraform.tfstate"
    # access_key            = "STORED IN ENV VARIABLE ARM_ACCESS_KEY"
  }
}

data "terraform_remote_state" "pub" {
  backend = "${var.backend}"
  config {
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.tags["client"]}/${var.environment}/publish/terraform.tfstate"
    # access_key            = "STORED IN ENV VARIABLE ARM_ACCESS_KEY"
  }
}

data "terraform_remote_state" "setup" {
  backend = "${var.backend}"
  config {
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.tags["client"]}/setup/terraform.tfstate"
    # access_key            = "STORED IN ENV VARIABLE ARM_ACCESS_KEY"
  }
}
