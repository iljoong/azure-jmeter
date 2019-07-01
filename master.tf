# master tf

# Create network interface
resource "azurerm_network_interface" "tfmasternic" {
  name                      = "${var.prefix}-master-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  network_security_group_id = "${azurerm_network_security_group.tfjmeternsg.id}"

  ip_configuration {
    name                          = "${var.prefix}-masternic-config"
    subnet_id                     = "${data.azurerm_subnet.jmetersnet.id}"
    #private_ip_address_allocation = "dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${replace(data.azurerm_subnet.jmetersnet.address_prefix, "0/24", "4")}" #"10.0.0.4"
    public_ip_address_id          = "${azurerm_public_ip.tfjmeterip.id}"
  }

  tags = {
    environment = "${var.tag}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "tfmastervm" {
  name                  = "${var.prefix}master"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfmasternic.id}"]
  vm_size               = "${var.vmsize}"

  storage_os_disk {
    name              = "${var.prefix}-master-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"

    disk_size_gb      = "128" # increase default os disk
  }

  /*
  # custom image
  storage_image_reference {
    id = "${var.osimageuri}"
  }
  */

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
      computer_name  = "jmmaster"
      admin_username = "${var.admin_username}"
      admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
      disable_password_authentication = false
  }

  tags = {
    environment = "${var.tag}"
  }
}

resource "azurerm_virtual_machine_extension" "mastervmext" {
  name                 = "mastervmext"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.tfmastervm.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "script": "${base64encode( file(var.vmscript))}"
    }
    SETTINGS

  tags = {
    environment = "${var.tag}"
  }
}

resource "azurerm_public_ip" "tfjmeterip" {
  name                         = "${var.prefix}-jmeterip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tfrg.name}"
  #public_ip_address_allocation = "static"
  allocation_method            = "Static"
  sku                          = "Basic" # "Standard"
}

output "jmeter_pip" {
  value = "${azurerm_public_ip.tfjmeterip.ip_address}"
}
