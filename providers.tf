terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">=3.70.0"
    }
  }
  required_version = ">=1.4.0"
}
provider "azurerm" {
  features {
  }
  subscription_id = "a6d4bb1c-5386-4a9a-af52-ef605eeea0b0"
}
