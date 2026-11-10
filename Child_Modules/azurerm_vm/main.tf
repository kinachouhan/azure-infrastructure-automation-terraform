data "azurerm_subnet" "subnet" {
   for_each = var.vm
  name = each.value.subnet_name
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_network_interface" "nic" {
   for_each = var.vm
  name = each.value.nic_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name = "internal"
    subnet_id = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
   for_each = var.vm
  name = each.value.vm_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  disable_password_authentication = false
  admin_username = ""
  admin_password = ""
  size = ""
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}




