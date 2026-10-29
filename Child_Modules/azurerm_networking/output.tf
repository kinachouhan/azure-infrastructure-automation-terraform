output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = {
    for name, subnet in azurerm_subnet.subnet : name => subnet.id
  }
}

