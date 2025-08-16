output "vm_admin_username" {
  description = "Admin username"
  value = azurerm_windows_virtual_machine.dev_vm.admin_username
}
output "vm_name" {
    description = "Name of the created VM"
  value = azurerm_windows_virtual_machine.dev_vm.name
}

output "vm_public_ip" {
    description = "Public IP address of the VM (RDP Access)"
    value = azurerm_public_ip.dev_vm_ip.ip_address
}

output "vm_private_ip" {
  description = "Private address of the VM"
  value = azurerm_network_interface.dev_vm_nic.ip_configuration[0].private_ip_address
}

output "rdp_connection_command" {
  description = "Command to connect via RDP"
  value = "mtsc /v:${azurerm_public_ip.dev_vm_ip.ip_address}"
}
# output "bastion_public_ip" {
#     description = "Public IP of bastion host (used by Azure Portal for secure RDP)"
#     value = azurerm_public_ip.bastion_ip.ip_address
# }

# output "bastion_host_name" {
#   description = "Name of the azure bastion host"
#   value=azurerm_bastion_host.dev_bastion.name
# }
