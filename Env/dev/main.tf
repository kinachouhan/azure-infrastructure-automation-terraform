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

module "kv" {
  depends_on = [ module.rgs ]
  source = "../../Child_Modules/azurerm_key_vault"
  kv = var.kv
}

module "vm" {
  depends_on = [ module.vnet , module.kv ]
  source = "../../Child_Modules/azurerm_vm"
  vm = var.vm
}