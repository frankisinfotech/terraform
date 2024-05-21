#-------------------
# Variables for VNET
#-------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "dev-spark-rg"
}

variable "location" {
  description = "Azure location"
  default     = "West Europe"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  default     = "dev-spark-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "dev-spark-sub1"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "dev-spark-sub2"
      address_prefix = "10.0.2.0/24"
    },
    {
      name           = "dev-spark-sub3"
      address_prefix = "10.0.3.0/24"
    }
  ]
}

#-----------------
# Variables for VM
#-----------------

variable "vm_count" {
  description = "Number of virtual machines to create"
  default     = 3
}

variable "vm_size" {
  description = "Size of the virtual machines"
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  default     = "ubuntu"
}

variable "public_ssh_key_path" {
  description = "Path to the public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}


#-----------------------------
# Variables for Azure MySQL DB
#-----------------------------

variable "mysql_server_name" {
  description = "Name of the MySQL server"
  default     = "devmysqlsvr"
}

variable "mysql_database_name" {
  description = "Name of the MySQL database"
  default     = "devdb"
}

variable "db_admin" {
  description = "Admin username for the MySQL server"
  default     = "devadmin"
}

variable "admin_password" {
  description = "Admin password for the MySQL server"
  default     = "xxxxxxxxxx"
}

variable "mysql_version" {
  description = "Version of MySQL"
  default     = "8.0.21"
}

variable "sku_name" {
  description = "SKU name for the MySQL server"
  default     = "B_Standard_B1s"
}

variable "storage_mb" {
  description = "Max storage for the MySQL server in MB"
  default     = 5120
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  default     = 7
}


#--------------------------
# Variables for Azure Cache
#--------------------------

variable "redis_cache_name" {
  description = "Name of the Redis cache instance"
  default     = "dev-sparkredis-cache"
}

variable "redis_cache_sku_name" {
  description = "SKU name for the Redis cache instance"
  default     = "Standard"
}

variable "redis_cache_sku_family" {
  description = "SKU family for the Redis cache instance"
  default     = "C"
}

variable "redis_cache_sku_capacity" {
  description = "SKU capacity for the Redis cache instance"
  default     = 1
}

variable "redis_cache_enable_non_ssl_port" {
  description = "Whether or not to enable the non-SSL port"
  default     = false
}
