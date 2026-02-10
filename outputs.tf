output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "bastion_name" {
  value = azurerm_bastion_host.bastion.name
}
