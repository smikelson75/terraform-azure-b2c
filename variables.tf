variable "domain_name" {
  type = string
  description = "Used to define the Azure AD B2C domain URL. Must be globally unique."
}

variable "app_display_name" {
    type = string
    description = "Provides the name for an Application Registration."
}