resource "azurerm_storage_account" "sa" {
   for_each = var.sa
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  account_replication_type = each.value.account_replication_type
  account_tier = each.value.account_tier
  location = each.value.location
}


resource "azurerm_storage_container" "container" {
  for_each = var.sa
  name = "kina-container"
  storage_account_id = azurerm_storage_account.sa[each.key].id
}

