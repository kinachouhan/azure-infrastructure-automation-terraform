
resource "azurerm_public_ip" "pip" {
  for_each = var.nat

  name                = each.value.public_ip.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  allocation_method = each.value.public_ip.allocation_method
  sku               = each.value.public_ip.sku
}

resource "azurerm_nat_gateway" "nat" {
  for_each = var.nat

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  for_each = var.nat

  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = azurerm_public_ip.pip[each.key].id
}

data "azurerm_subnet" "subnet" {
  for_each = {
    for item in flatten([
      for nat_key, nat_value in var.nat : [
        for subnet in nat_value.subnet_names : {
          key                 = "${nat_key}-${subnet}"
          subnet_name         = subnet
          resource_group_name = nat_value.resource_group_name
          virtual_network_name = nat_value.virtual_network_name
        }
      ]
    ]) : item.key => item
  }

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_subnet_nat_gateway_association" "nat" {
  for_each = data.azurerm_subnet.subnet

  subnet_id = each.value.id

  nat_gateway_id = azurerm_nat_gateway.nat[
    split("-", each.key)[0]
  ].id
}
