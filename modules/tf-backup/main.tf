resource "random_integer" "random" {
  min = 1
  max = 1000
}

resource "azurerm_recovery_services_vault" "backup" {
  name                = "${var.azurename_prefix}-backupvault-${random_integer.random.result}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "standard"

  tags {
     client       = "${var.tags["client"]}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

resource "azurerm_recovery_services_protection_policy_vm" "backup" {
  name                = "${var.azurename_prefix}-backup-policy"
  resource_group_name = "${var.resource_group_name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.backup.name}"

  #timezone = "${var.serverinfo["timezone"]}"
  # https://docs.microsoft.com/en-us/previous-versions/windows/embedded/gg154758(v=winembedded.80)

  backup = {
    frequency = "Daily"
    time      = "${var.serverinfo["backuptime"]}"
  }

  retention_daily = {
    count = "${var.serverinfo["dailyretention"]}"
  }

  retention_weekly = {
    count    = "${var.serverinfo["weeklyyretention"]}"
    weekdays = ["Sunday"]
  }

  retention_monthly = {
    count    = "${var.serverinfo["monthlyretention"]}"
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }
}
