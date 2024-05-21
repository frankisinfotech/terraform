#----------------
# Azure DB Server
#----------------

resource "azurerm_mysql_flexible_server" "sparksvr" {
  name                              = var.mysql_server_name
  location                          = azurerm_resource_group.sparkrg.location
  resource_group_name               = azurerm_resource_group.sparkrg.name

  administrator_login               = var.db_admin
  administrator_password            = var.admin_password
  version                           = var.mysql_version
  sku_name                          = var.sku_name
  #storage_mb                        = var.storage_mb
  #backup_retention_days             = var.backup_retention_days
#  geo_redundant_backup_enabled      = false
  #auto_grow_enabled                 = true
  #ssl_enforcement_enabled           = true
  #ssl_minimal_tls_version_enforced  = "TLS1_2"
  #infrastructure_encryption_enabled = true
 

 # lifecycle {
 #   prevent_destroy = true
 # }
}


#-----------------------
# Azure DB Configuration
#-----------------------

resource "azurerm_mysql_flexible_database" "sparkdb" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.sparkrg.name
  server_name         = azurerm_mysql_flexible_server.sparksvr.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
