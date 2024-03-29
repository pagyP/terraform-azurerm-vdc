resource "azurerm_resource_group" "vnet" {
  name                = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "subnet" {
  name                      = "${var.subnet_names[count.index]}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.vnet.name}"
  address_prefix            = "${var.subnet_prefixes[count.index]}"
  count                     = "${length(var.subnet_names)}"
}

resource "azurerm_subnet_route_table_association" "route_table" {
  subnet_id      = "${azurerm_subnet.subnet[count.index].id}"
  route_table_id = "${var.route_table_id}"
  count          = "${length(var.subnet_names)}"
}