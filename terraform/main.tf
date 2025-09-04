
/////////////////////////////////////////////  creation  Rg et virt net  et Sg   ///////////////////////////////////////////////////////////////////////////


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_resource_group.rg]
}
resource "azurerm_network_security_group" "nsg_ssh" {
  name                = "nsg-ssh"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
} 
////////////////////////////////////////////////// Jenkins Master/////////////////////////////////////////////////////////////////////////////////////////////////////
resource "azurerm_subnet" "private_master" {
  name                 = var.private_subnet_master
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.master_subnet_prefix

  depends_on = [azurerm_virtual_network.vnet]
}
resource "azurerm_public_ip" "master_ip" {
  name                = "master-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
 sku                 = "Standard"
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_interface" "nic_master" {
  name                = "nic-master"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                    = azurerm_subnet.private_master.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master_ip.id
  }

  depends_on = [azurerm_subnet.private_master, azurerm_public_ip.master_ip]
}

resource "azurerm_network_interface_security_group_association" "nic_master_nsg" {
  network_interface_id      = azurerm_network_interface.nic_master.id
  network_security_group_id = azurerm_network_security_group.nsg_ssh.id
}
resource "azurerm_linux_virtual_machine" "master" {
  name                  = "vm-jenkins_master"
   computer_name         = "jenkinsmaster"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size_master
  admin_username = data.vault_kv_secret_v2.jenkins.data["admin_username"]
  admin_password = data.vault_kv_secret_v2.jenkins.data["admin_password"]
  admin_ssh_key {
  username   = data.vault_kv_secret_v2.jenkins.data["admin_username"]
  public_key = data.vault_kv_secret_v2.jenkins.data["public_key"]

}

  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.nic_master.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
     disk_size_gb = 30
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  depends_on = [azurerm_network_interface.nic_master]
}
//////////////////////////////////////////////////////////////////Jenkins Slave/////////////////////////////////////////////////////////////////////////////////////
resource "azurerm_subnet" "private_slave" {
  name                 = var.private_subnet_slave
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.slaver_subnet_prefix

  depends_on = [azurerm_virtual_network.vnet]
}




resource "azurerm_network_interface" "nic_slave" {
  name                = "nic-slave"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                    = azurerm_subnet.private_slave.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet.private_slave]
}


resource "azurerm_network_interface_security_group_association" "nic_slave_nsg" {
  network_interface_id      = azurerm_network_interface.nic_slave.id
  network_security_group_id = azurerm_network_security_group.nsg_ssh.id
}



resource "azurerm_linux_virtual_machine" "slave" {
  name                = "vm-jenkins_slave"
  computer_name       = "jenkinsslave"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size_slave   # CPU/RAM/stockage

  # Utilisateurs récupérés depuis Vault
  admin_username = data.vault_kv_secret_v2.jenkins.data["admin_username"]
  admin_password = data.vault_kv_secret_v2.jenkins.data["admin_password"]
admin_ssh_key {
  username   = data.vault_kv_secret_v2.jenkins.data["admin_username"]
  public_key = data.vault_kv_secret_v2.jenkins.data["public_key"]

}

  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.nic_slave.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  depends_on = [azurerm_network_interface.nic_slave]
}