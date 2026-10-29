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

vnet = {
    vnet1 = {
        name = "vnet-1"
        resource_group_name = "rg-1"
        location = "Central India"
        address_space = ["10.0.0.0/16"]
    }
}

subnet = {
    sub1 = {
        name = "subnet-1"
        resource_group_name = "rg-1"
        address_prefixes = ["10.0.1.0/24"]
    }
}