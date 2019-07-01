# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg" {
    name     = "${var.rgname}"
    location = "${var.location}"
}

/*
# Create virtual network
resource "azurerm_virtual_network" "tfvnet" {
    name                = "${var.vnetname}"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"

}

resource "azurerm_subnet" "jmetersnet" {
  name                 = "${var.subnetname}"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  address_prefix       = "10.0.0.0/24"
}
*/

# use existing vnet
data "azurerm_virtual_network" "tfvnet" {
  name                = "${var.vnetname}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
}

data "azurerm_subnet" "jmetersnet" {
  name                 = "${var.subnetname}"
  virtual_network_name = "${data.azurerm_virtual_network.tfvnet.name}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
}

resource "azurerm_network_security_group" "tfjmeternsg" {
  name                = "${var.prefix}nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.tag}"
  }
}
