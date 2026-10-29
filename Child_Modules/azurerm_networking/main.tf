resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnet
  name =  each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space = each.value.address_space
}


resource "azurerm_subnet" "subnet" {
  for_each = var.subnet
  name = each.value.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = each.value.resource_group_name
  address_prefixes = each.value.address_prefixes
}