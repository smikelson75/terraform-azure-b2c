# Resource group to contain Azure Resources built by
# Terraform
resource "azurerm_resource_group" "azb2c_tutorial" {
  name     = "rg-azadb2c-tutorial-eastus"
  location = "eastus"
}
