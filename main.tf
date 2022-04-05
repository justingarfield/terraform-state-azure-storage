terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  #backend "azurerm" {
  #  resource_group_name  = "my-tf-state"
  #  storage_account_name = "mytfstatestorage"
  #  container_name       = "terraform-state-files"
  #  key                  = "tf-state-storage.tfstate"
  #}
}

locals {
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
  location = "East US 2"
  tags     = local.tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "mytfstatestorage"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = "East US 2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "state-files-container" {
  name                 = "terraform-state-files"
  storage_account_name = azurerm_storage_account.storage_account.name
}