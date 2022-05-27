#---------------
# Resource Group
#----------------
resource "azurerm_resource_group" "demorg" {
  name     = "vm-${terraform.workspace}-rg"
  location = "West Europe"
}

#---------------------
#Network Security Group
#----------------------
resource "azurerm_network_security_group" "demosg" {
  name                = "ng-${terraform.workspace}-sg"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name

  security_rule {
    name                       = "ssh-${terraform.workspace}-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${terraform.workspace}-nsg"
  }
}

#--------------
#Virtual Network
#---------------
resource "azurerm_virtual_network" "demovnet" {
  name                = "vnet-${terraform.workspace}-network"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  tags = {
    environment = "${terraform.workspace}-net"
  }

}

#-------
# Subnet
#--------
resource "azurerm_subnet" "demosub" {
  name                 = "sub-${terraform.workspace}-net"
  resource_group_name  = azurerm_resource_group.demorg.name
  virtual_network_name = azurerm_virtual_network.demovnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#-----------------
#Network Interface
#-----------------
resource "azurerm_network_interface" "demonic" {
  name                = "${terraform.workspace}-nic"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name

  ip_configuration {
    name                          = "ip-${terraform.workspace}-conf"
    subnet_id                     = azurerm_subnet.demosub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.demoip.id}"


  }
}

#---------
#Public IP
#---------
resource "azurerm_public_ip" "demoip" {
  name                    = "pub-${terraform.workspace}-ip"
  location                = "${azurerm_resource_group.demorg.location}"
  resource_group_name     = "${azurerm_resource_group.demorg.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}


#----------------
# Virtual Machine
#----------------
resource "azurerm_linux_virtual_machine" "demovm" {
  name                = "vm-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  size                = "Standard_D2as_v5"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.demonic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("demokey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
