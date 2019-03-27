resource "azurerm_public_ip" "lb" {
  name                          = "${var.azurename_prefix}lbip"
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

resource "azurerm_lb" "lb" {
  name                = "${var.azurename_prefix}lb"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "${var.azurename_prefix}lbip"
    public_ip_address_id = "${azurerm_public_ip.lb.id}"
  }

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "${var.azurename_prefix}-backend_address_pool"
}

resource "azurerm_lb_rule" "lb1" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.azurename_prefix}lbip"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe.id}"
  depends_on                     = ["azurerm_lb_probe.load_balancer_probe"]
}

resource "azurerm_lb_rule" "lb2" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  name                           = "HTTPS"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${var.azurename_prefix}lbip"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe.id}"
  depends_on                     = ["azurerm_lb_probe.load_balancer_probe"]
}

resource "azurerm_lb_probe" "load_balancer_probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  name                = "HTTP_en_homepage"
  port                = "80"
  protocol            = "HTTP"
  request_path        = "${var.tracked_url}"
  interval_in_seconds = 5
  number_of_probes    = 2
}

# edit NIcs for Publishers
resource "azurerm_network_interface" "nic" {
  depends_on                = ["azurerm_lb_probe.load_balancer_probe"]
  count                     = "${var.serverscount}"

  name                      = "${var.hostname}${count.index}nic"
  location                  = "${var.region}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.network_security_group_id}"

  ip_configuration {
     name                                     = "${var.hostname}${count.index}ip"
     subnet_id                                = "${var.subnet_id}"
     private_ip_address_allocation            = "Dynamic"
     public_ip_address_id                     = "${element(var.public_ip_address_id, count.index)}"
     # load_balancer_backend_address_pools_ids  = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }

  tags {
     role         = "${var.serverinfo["role"]}"
     client       = "${var.tags["client"]}"
     environment  = "${var.environment}"
     costcenter   = "${var.tags["costcenter"]}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "lb" {
  network_interface_id    = "${azurerm_network_interface.nic.id}"
  ip_configuration_name   = "${var.hostname}${count.index}ip"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.backend_pool.id}"
}
