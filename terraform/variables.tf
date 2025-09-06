variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "rg-jenkins"
}

variable "vnet_name" {
  default = "vnet-jenkins"
}

variable "private_subnet_slave" {
  default = "private_subnet_slave"
}

variable "private_subnet_master" {
  default = "private_subnet_master"
}

variable "address_space" {
  default = ["10.10.0.0/16"]

}

variable "master_subnet_prefix" {
  default = ["10.10.1.0/24"]
}

variable "slaver_subnet_prefix" {
  default = ["10.10.2.0/24"]
}


variable "vm_size_master" {
  default = "Standard_B2s"
}
variable "vm_size_slave" {
  default = "Standard_B1s"
}

variable "image" {
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


}