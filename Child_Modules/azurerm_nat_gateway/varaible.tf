
variable "nat" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku_name             = string
    idle_timeout         = number

    public_ip = object({
      name              = string
      allocation_method = string
      sku               = string
    })

    virtual_network_name = string
    subnet_names         = set(string)
  }))
}
