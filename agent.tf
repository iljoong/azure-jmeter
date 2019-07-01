# agent.tf
# Create network interface
resource "azurerm_network_interface" "tfagtnic" {
  count                     = "${var.agtcount}"
  name                      = "${var.prefix}-agtnic${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.tfrg.name}"
  network_security_group_id = "${azurerm_network_security_group.tfjmeternsg.id}"

  ip_configuration {
    name                          = "${var.prefix}-agtnic-config${count.index}"
    subnet_id                     = "${data.azurerm_subnet.jmetersnet.id}"
    #private_ip_address_allocation = "dynamic"
    private_ip_address_allocation = "Static"
    #private_ip_address            = "${format("10.0.0.%d", count.index + 10)}"
    private_ip_address             = "${replace(data.azurerm_subnet.jmetersnet.address_prefix, "0/24", format("%d", count.index + 10))}"
  }

  tags = {
    environment = "${var.tag}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "tfagtvm" {
  count                 = "${var.agtcount}"
  name                  = "${var.prefix}agtvm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tfrg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfagtnic.*.id[count.index]}"]
  vm_size               = "${var.vmsize}"

  storage_os_disk {
    name              = "${format("%s-agt-%03d-osdisk", var.prefix, count.index + 1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"

    #disk_size_gb      = "100" # increase default os disk
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
      computer_name  = "${format("tfagtvm%03d", count.index + 1)}"
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

resource "azurerm_virtual_machine_extension" "agentvmext" {
  count                = "${var.agtcount}"
  name                 = "agtvmext"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.tfagtvm.*.name[count.index]}"
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
