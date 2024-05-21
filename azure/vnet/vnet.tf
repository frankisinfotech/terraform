resource "azurerm_resource_group" "sparkrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "sparkvnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.sparkrg.location
  resource_group_name = azurerm_resource_group.sparkrg.name
}

resource "azurerm_subnet" "sparksubnet" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index].name
  resource_group_name  = azurerm_resource_group.sparkrg.name
  virtual_network_name = azurerm_virtual_network.sparkvnet.name
  address_prefixes     = [var.subnets[count.index].address_prefix]
}

#----------------------------------
# Associate the NSG with the subnet
#----------------------------------
resource "azurerm_subnet_network_security_group_association" "sparkansg" {
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.sparksubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.sparknsg.id
}
