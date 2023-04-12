provider "azurerm" {
  features {
    
  }
}

provider "azuread" {
    tenant_id = azurerm_aadb2c_directory.tutorial_tenant.tenant_id
}