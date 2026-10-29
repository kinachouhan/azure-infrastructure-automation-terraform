module "rgs" {
 source = "../../Child_Modules/azurerm_rg"
 rg = var.rg
}

module "vnet" {
  depends_on = [ module.rgs ]
  source = "../../Child_Modules/azurerm_networking"
  vnet = var.vnet
  subnet = var.subnet
}


