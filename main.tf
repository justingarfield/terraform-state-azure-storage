terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  
  # Note: These values must be populated with whatever names were chosen for your Resource Group and Storage Account.
  #       Variables cannot be used here, as this affects `terraform init`, not `plan` or `apply`
  #       Only uncomment the lines below AFTER the first set of steps, or else you'll get errors.
  #backend "azurerm" {
  #  resource_group_name  = "my-tf-state"
  #  storage_account_name = "mytfstatestorage"
  #  container_name       = "terraform-state-files"
  #  key                  = "tf-state-storage.tfstate"
  #}
}

locals {
  location = "East US 2"
  tfVersion = "1.1.7" # The version of Terraform being used to provision resources. Used for tagging.
  tags = {
    terraform = "${local.tfVersion}"
    category  = "Infrastructure"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "my-tf-state"
  location = local.location
  tags     = local.tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "mytfstatestorage"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "state-files-container" {
  name                 = "terraform-state-files"
  storage_account_name = azurerm_storage_account.storage_account.name
}