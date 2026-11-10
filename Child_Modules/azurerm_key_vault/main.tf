data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.kv
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  rbac_authorization_enabled = true
  enabled_for_disk_encryption = true
  tenant_id = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled = false
  sku_name = "standard"
}


resource "azurerm_role_assignment" "kv_secret_user" {
 for_each = var.kv
  scope = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Secrets User"
  principal_id = data.azurerm_client_config.current.object_id
}


