
# ---------------- RESOURCE GROUP ----------------

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

  bastion = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "axion-dev-rg"
    address_prefixes     = ["10.0.3.0/26"]
    virtual_network_name = "axion-dev-vnet"
  }
  appgateway = {
    name                 = "appgateway-subnet"
    resource_group_name  = "axion-dev-rg"
    virtual_network_name = "axion-dev-vnet"
    address_prefixes     = ["10.0.4.0/24"]
  }
    database = {
    name                 = "database-subnet"
    resource_group_name  = "axion-dev-rg"
    virtual_network_name = "axion-dev-vnet"
    address_prefixes     = ["10.0.5.0/24"]
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

    size = "Standard_D2als_v6"
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

    size = "Standard_D2als_v6"
  }

  database = {
    vm_name              = "axion-database-vm"
    nic_name             = "axion-database-nic"
    subnet_name          = "database-subnet"
    virtual_network_name = "axion-dev-vnet"
    resource_group_name  = "axion-dev-rg"
    location             = "Central India"

    kv_name                = "axiondevkv2026"
    kv_resource_group_name = "axion-dev-rg"

    size = "Standard_D2als_v6"
  }
}


# ---------------- BASTION ----------------

bastion = {
  bastion1 = {
    name                 = "axion-dev-bastion"
    location             = "Central India"
    resource_group_name  = "axion-dev-rg"
    subnet_name          = "AzureBastionSubnet"
    virtual_network_name = "axion-dev-vnet"
    public_ip_name       = "axion-dev-bastion-pip"
  }
}



nat = {
  nat1 = {
    name                = "axion-dev-nat"
    location            = "Central India"
    resource_group_name = "axion-dev-rg"
    sku_name            = "Standard"
    idle_timeout        = 10

    public_ip = {
      name              = "axion-dev-nat-pip"
      allocation_method = "Static"
      sku               = "Standard"
    }

    virtual_network_name = "axion-dev-vnet"

    subnet_names = [
      "frontend-subnet",
      "backend-subnet",
      "database-subnet"
    ]
  }
}


appgw = {
  appgw1 = {
    name                = "axion-dev-appgw"
    location            = "Central India"
    resource_group_name = "axion-dev-rg"

    subnet_name          = "appgateway-subnet"
    virtual_network_name = "axion-dev-vnet"
    backend_private_ip   = "10.0.1.4"

    sku_name = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2

    public_ip_name    = "axion-dev-appgw-pip"
    allocation_method = "Static"
    public_ip_sku     = "Standard"
  }
}


nsg = {
  frontend = {
    name                 = "axion-frontend-nsg"
    location             = "Central India"
    resource_group_name  = "axion-dev-rg"
    subnet_name          = "frontend-subnet"
    virtual_network_name = "axion-dev-vnet"

    rules = {
      allow_appgw_http = {
        name                       = "Allow-AppGW-HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.0.4.0/24"
        destination_address_prefix = "*"
      }

      allow_bastion_ssh = {
        name                       = "Allow-Bastion-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.3.0/26"
        destination_address_prefix = "*"
      }

      deny_other_vnet_inbound = {
        name                       = "Deny-Other-VNet-Inbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    }
  }

  backend = {
    name                 = "axion-backend-nsg"
    location             = "Central India"
    resource_group_name  = "axion-dev-rg"
    subnet_name          = "backend-subnet"
    virtual_network_name = "axion-dev-vnet"

    rules = {
      allow_frontend_api = {
        name                       = "Allow-Frontend-API"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8000"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "*"
      }

      allow_bastion_ssh = {
        name                       = "Allow-Bastion-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.3.0/26"
        destination_address_prefix = "*"
      }

      deny_other_vnet_inbound = {
        name                       = "Deny-Other-VNet-Inbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    }
  }
    database = {
    name                 = "axion-database-nsg"
    location             = "Central India"
    resource_group_name  = "axion-dev-rg"
    subnet_name          = "database-subnet"
    virtual_network_name = "axion-dev-vnet"

    rules = {
      allow_backend_postgres = {
        name                       = "Allow-Backend-PostgreSQL"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5432"
        source_address_prefix      = "10.0.2.0/24"
        destination_address_prefix = "*"
      }

      allow_bastion_ssh = {
        name                       = "Allow-Bastion-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.3.0/26"
        destination_address_prefix = "*"
      }

      deny_other_vnet_inbound = {
        name                       = "Deny-Other-VNet-Inbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    }
  }
}

