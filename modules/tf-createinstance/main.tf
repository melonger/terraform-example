# Create public IPs
resource "azurerm_public_ip" "servers" {
  count                         = "${var.serverscount}"
  name                          = "${var.hostname}${count.index}ip"

  location                      = "${var.region}"
  resource_group_name           = "${var.resource_group_name}"
  allocation_method             = "Static" # [Static|Dynamic] Must have capitalization

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.azurename_prefix}${var.serverinfo["role"]}avset"
  location                     = "${var.region}"
  resource_group_name          = "${var.resource_group_name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  count                     = "${var.serverscount}"
  name                      = "${var.hostname}${count.index}nic"

  location                  = "${var.region}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.network_security_group_id}"

  ip_configuration {
     name                          = "${var.hostname}${count.index}ip"
     subnet_id                     = "${var.subnet_id}"
     private_ip_address_allocation = "dynamic"
     public_ip_address_id          = "${element(azurerm_public_ip.servers.*.id, count.index)}"
  }

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

# Create Data Disk
resource "azurerm_managed_disk" "datadisk" {
  count                = "${var.serverscount}"
  name                 = "${var.hostname}${count.index}-datadisk"
  location             = "${var.region}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "${var.serverinfo["storage_managed_disk_type"]}"
  create_option        = "Empty"
  disk_size_gb         = "${var.serverinfo["storage_disk_size_gb"]}"

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

resource "azurerm_virtual_machine" "server" {
  count                 = "${var.serverscount}"
  name                  = "${var.hostname}${(count.index + var.serverinfo["startindex"])}"
  location              = "${var.region}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  availability_set_id   = "${azurerm_availability_set.avset.id}"
  vm_size               = "${var.serverinfo["size"]}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_os_disk {
     name              = "${var.hostname}${count.index}-disk"
     caching           = "${var.serverinfo["storage_caching"]}"
     create_option     = "${var.serverinfo["storage_create_option"]}"
     managed_disk_type = "${var.serverinfo["storage_managed_disk_type"]}"
  }

  storage_data_disk {
    name              = "${var.hostname}${(count.index + var.serverinfo["startindex"])}-datadisk"
    managed_disk_id   = "${element(azurerm_managed_disk.datadisk.*.id, count.index)}"
    managed_disk_type = "${var.serverinfo["storage_managed_disk_type"]}"
    disk_size_gb      = "${var.serverinfo["storage_disk_size_gb"]}"
    create_option     = "Attach"
    lun               = "${(count.index + var.serverinfo["startindex"])}"
  }

  storage_image_reference {
     publisher = "${var.serverinfo["storage_publisher"]}"
     offer     = "${var.serverinfo["storage_offer"]}"
     sku       = "${var.serverinfo["storage_sku"]}"
     version   = "${var.serverinfo["storage_version"]}"
  }

  os_profile {
     computer_name  = "${var.hostname}${(count.index + var.serverinfo["startindex"])}"
     admin_username = "${var.os_user}"
     # admin_password = "${var.adminpassword}"
     # custom_data    = "${data.template_cloudinit_config.config.rendered}"
  }

  os_profile_linux_config {
     disable_password_authentication = true
     ssh_keys {
         path     = "/home/${var.os_user}/.ssh/authorized_keys"
         # key_data = "${file(var.ssh_public_key)}"
         key_data = "${var.ssh_public_key}"
     }
  }

  boot_diagnostics {
     enabled = "true"
     storage_uri = "https://${lower(var.tags["client"])}storageacct.blob.core.windows.net/" #variable created in 0-setup storage module in main.tf
  }

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}
