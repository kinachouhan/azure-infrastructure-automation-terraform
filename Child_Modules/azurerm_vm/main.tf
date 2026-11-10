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

data "azurerm_key_vault" "kv" {
    for_each = var.vm
  name = each.value.kv_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_key_vault_secret" "vm_username" {
   for_each = var.vm
  name = "vmUsername"
  value = each.value.admin_username
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

resource "azurerm_key_vault_secret" "vm_password" {
   for_each = var.vm
  name = "vmPassword"
  value = each.value.admin_password
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}


resource "azurerm_linux_virtual_machine" "vm" {
   for_each = var.vm
  name = each.value.vm_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  disable_password_authentication = false
  admin_username = azurerm_key_vault_secret.vm_username
  admin_password = azurerm_key_vault_secret.vm_password
  size = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}




