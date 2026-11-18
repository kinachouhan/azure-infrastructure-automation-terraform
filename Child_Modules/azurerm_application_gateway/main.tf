
data "azurerm_subnet" "appgw" {
  for_each = var.appgw

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_public_ip" "appgw" {
  for_each = var.appgw

  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.public_ip_sku
}

resource "azurerm_application_gateway" "appgw" {
  for_each = var.appgw

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.tier
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = data.azurerm_subnet.appgw[each.key].id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw[each.key].id
  }

  backend_address_pool {
    name         = "frontend-backend-pool"
    ip_addresses = [each.value.backend_private_ip]
  }
  
  probe {
  name                = "frontend-health-probe"
  protocol            = "Http"
  path                = "/"
  interval            = 30
  timeout             = 30
  unhealthy_threshold = 3

  host = each.value.backend_private_ip

  match {
    status_code = ["200-399"]
  }
}

  backend_http_settings {
    name                  = "frontend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "frontend-health-probe"
  }

  http_listener {
    name                           = "frontend-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "frontend-routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "frontend-http-listener"
    backend_address_pool_name  = "frontend-backend-pool"
    backend_http_settings_name = "frontend-http-settings"
  }
}
