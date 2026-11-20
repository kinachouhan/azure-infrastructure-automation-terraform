
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.kv

  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  rbac_authorization_enabled = true
  enabled_for_disk_encryption = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
}

resource "azurerm_role_assignment" "kv_secret_user" {
  for_each = var.kv

  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}



resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv["kv1"].id

  depends_on = [
    azurerm_role_assignment.kv_secret_user
  ]
}