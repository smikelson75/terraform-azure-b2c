# Builds out the Azure AD B2c Tenant
# Warning! Once the tenant is built, it must be MANUALLY deleted based on
# several.
# https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-tenant
resource "azurerm_aadb2c_directory" "tutorial_tenant" {
  resource_group_name = azurerm_resource_group.azb2c_tutorial.name
  display_name = "b2c-aadb2c-tutorial-us"
  domain_name = var.domain_name
  country_code = "US"
  data_residency_location = "United States"
  sku_name = "PremiumP1"
}

# Create an Application Registration used for application login
# https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-ga
resource "azuread_application" "general" {
  display_name = var.app_display_name
  sign_in_audience = "AzureADMultipleOrgs"
  web {
    redirect_uris = [ "https://jwt.ms/" ]
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id = azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
      type = "Scope"
    }

    resource_access {
      id = azuread_service_principal.msgraph.oauth2_permission_scope_ids["offline_access"]
      type = "Scope"
    }
  }
}

# Required to get the Application's Object ID for Granting Admin Consent
resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

# Required to get the new Application Registration's Object Id
resource "azuread_service_principal" "general" {
  application_id = azuread_application.general.application_id
}

# Grant Admin Consent for OpenID and Offline Access to the 
# Application Registered.
resource "azuread_service_principal_delegated_permission_grant" "general" {
  service_principal_object_id = azuread_service_principal.general.object_id
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
  claim_values = [ "openid", "offline_access" ]
}

data "azuread_application_published_app_ids" "well_known" {}