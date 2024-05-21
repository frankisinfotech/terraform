#----------
# Public IP
#----------

resource "azurerm_public_ip" "sparkpip" {
  count               = var.vm_count
  name                = "dev-pip-${count.index}"
  location            = azurerm_resource_group.sparkrg.location
  resource_group_name = azurerm_resource_group.sparkrg.name
  allocation_method   = "Dynamic"
}

#------------------
# Network Interface
#------------------

resource "azurerm_network_interface" "sparknic" {
  count               = var.vm_count
  name                = "dev-nic-${count.index}"
  location            = azurerm_resource_group.sparkrg.location
  resource_group_name = azurerm_resource_group.sparkrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sparksubnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sparkpip[count.index].id
  }
}

#---------------
# Public Keypair
#---------------

resource "azurerm_ssh_public_key" "sparkkey" {
  name                = "dev-vm-key"
  resource_group_name = azurerm_resource_group.sparkrg.name
  location            = azurerm_resource_group.sparkrg.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

#------------
#Local Values
#------------

locals {
  public_ssh_key = file(var.public_ssh_key_path)
}

#----------------
# Virtual Machine
#----------------

resource "azurerm_virtual_machine" "sparkvm" {
  count                 = var.vm_count
  name                  = "dev-vm-${count.index}"
  location              = azurerm_resource_group.sparkrg.location
  resource_group_name   = azurerm_resource_group.sparkrg.name
  network_interface_ids = [azurerm_network_interface.sparknic[count.index].id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "dev-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  

  os_profile {
    computer_name  = "dev-vm-${count.index}"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
    path      = "/home/${var.admin_username}/.ssh/authorized_keys"
    key_data  = local.public_ssh_key
  }
  }
}

