#--------------------
# Redis Configuration
#--------------------

resource "azurerm_redis_cache" "sparkredis" {
  name                = var.redis_cache_name
  location            = azurerm_resource_group.sparkrg.location
  resource_group_name = azurerm_resource_group.sparkrg.name

  sku_name                      = var.redis_cache_sku_name
  family                        = var.redis_cache_sku_family
  capacity                      = var.redis_cache_sku_capacity
  public_network_access_enabled = true

  enable_non_ssl_port           = var.redis_cache_enable_non_ssl_port

  redis_configuration {
    maxmemory_reserved          = "2"
    maxmemory_delta             = "2"
    maxmemory_policy            = "allkeys-lru"
  }

  lifecycle {
    prevent_destroy = true
  }
}
