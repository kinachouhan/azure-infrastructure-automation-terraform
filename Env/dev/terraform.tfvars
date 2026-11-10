rg = {
  rg1 = {
    name     = "axion-dev-rg"
    location = "Central India"

    tags = {
      environment = "dev"
      managed_by  = "terraform"
      project     = "azure-infrastructure-automation"
    }
  }
}

# ---------------- VNET ----------------

vnet = {
  vnet1 = {
    name                = "axion-dev-vnet"
    resource_group_name = "axion-dev-rg"
    location            = "Central India"
    address_space       = ["10.0.0.0/16"]
  }
}

# ---------------- SUBNETS ----------------

subnet = {
  frontend = {
    name                 = "frontend-subnet"
    resource_group_name  = "axion-dev-rg"
    address_prefixes     = ["10.0.1.0/24"]
    virtual_network_name = "axion-dev-vnet"
  }

  backend = {
    name                 = "backend-subnet"
    resource_group_name  = "axion-dev-rg"
    address_prefixes     = ["10.0.2.0/24"]
    virtual_network_name = "axion-dev-vnet"
  }
}

# ---------------- KEY VAULT ----------------

kv = {
  kv1 = {
    name                = "axiondevkv2026"
    location            = "Central India"
    resource_group_name = "axion-dev-rg"
  }
}

# ---------------- VIRTUAL MACHINES ----------------
vm = {
  frontend = {
    vm_name              = "axion-frontend-vm"
    nic_name             = "axion-frontend-nic"
    subnet_name          = "frontend-subnet"
    virtual_network_name = "axion-dev-vnet"
    resource_group_name  = "axion-dev-rg"
    location             = "Central India"

    kv_name                = "axiondevkv2026"
    kv_resource_group_name = "axion-dev-rg"

    admin_username = "kinaadmin"
    admin_password = "YourStrongPassword!"
    size           = "Standard_D2als_v6"
  }

  backend = {
    vm_name              = "axion-backend-vm"
    nic_name             = "axion-backend-nic"
    subnet_name          = "backend-subnet"
    virtual_network_name = "axion-dev-vnet"
    resource_group_name  = "axion-dev-rg"
    location             = "Central India"

    kv_name                = "axiondevkv2026"
    kv_resource_group_name = "axion-dev-rg"

    admin_username = "kinaadmin"
    admin_password = "AnotherStrongPassword!"
    size           = "Standard_D2als_v6"
  }
}