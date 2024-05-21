#---------------------
#Network Security Group
#----------------------

resource "azurerm_network_security_group" "sparknsg" {
  name                = "dev-spark-nsg"
  location            = azurerm_resource_group.sparkrg.location
  resource_group_name = azurerm_resource_group.sparkrg.name

  dynamic "security_rule" {
    for_each = local.security_rules 
    content {
      name                       = security_rule.value.name
      priority                   = local.security_rules_with_priority[security_rule.value.name]
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
      

  tags = {
    "environment" = "dev-spark-nsg"
    "Terraform Managed" = "Yes"
  }  
}
