# Local value to hold the security rules
locals {
  security_rules = [
    {
      name                        = "SSH"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "22"
      source_address_prefix       = "0.0.0.0/0"
      destination_address_prefix  = "*"
    },
    {
      name                        = "HTTP"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "80"
      source_address_prefix       = "0.0.0.0/0"
      destination_address_prefix  = "*"
    }
  ]

  # Create a map of rule names to their calculated priorities
  security_rules_with_priority = zipmap(
    [for i, rule in local.security_rules : rule.name],
    [for i in range(length(local.security_rules)) : 1000 + i]
  )
}
