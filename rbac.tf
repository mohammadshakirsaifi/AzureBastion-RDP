resource "azurerm_role_assignment" "vm_admin" {
  scope                = azurerm_windows_virtual_machine.vm.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = var.aad_admin_object_id
}
