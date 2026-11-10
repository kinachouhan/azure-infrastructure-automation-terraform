data "azurerm_subnet" "bastion" {
  for_each = var.bastion

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_public_ip" "bastion" {
  for_each = var.bastion

  name                = each.value.public_ip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  for_each = var.bastion

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  copy_paste_enabled = true
  file_copy_enabled  = false
  ip_connect_enabled = true
  tunneling_enabled  = false

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.bastion[each.key].id
    public_ip_address_id = azurerm_public_ip.bastion[each.key].id
  }
}