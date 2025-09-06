output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "master_subnet_id" {
  value = azurerm_subnet.private_master.id
}

output "slave_subnet_id" {
  value = azurerm_subnet.private_slave.id
}

output "master_private_ip" {
  value = azurerm_network_interface.nic_master.private_ip_address
}

output "slave_private_ip" {
  value = azurerm_network_interface.nic_slave.private_ip_address
}

output "master_public_ip" {
  value = azurerm_public_ip.master_ip.ip_address
}

output "master_vm_id" {
  value = azurerm_linux_virtual_machine.master.id
}

output "slave_vm_id" {
  value = azurerm_linux_virtual_machine.salve.id
}
