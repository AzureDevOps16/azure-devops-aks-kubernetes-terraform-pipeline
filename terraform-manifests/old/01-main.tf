# We will define 
# 1. Terraform Settings Block
#   1. Required Version Terraform
#   2. Required Terraform Providers
#   3. Terraform Remote State Storage with Azure Storage Account (last step of this section)
# 2. Terraform Provider Block for AzureRM
# 3. Terraform Resource Block: Define a Random Pet Resource

# 1. Terraform Settings Block
terraform {
  #   1. Required Version Terraform
  required_version = ">=1.4.6"
  #   2. Required Terraform Providers
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

  }

  # Terraform State Storage to Azure Storage Container
  # manually create resource group, storage account on that resource group,
  # container on the that storage account and then upload the terraform.tfstate file into the container
  # and then add those info in below object
  # This block is going to help you to upload the terraform.tfstate file into storage account
  # so that everyone can use the same tfstate file.
  # After doing this changes again run "terraform init".
  # No local dependency now. Straight away initialize your terraform files from any folder and start working

  #    backend "azurerm" {
  #      resource_group_name   = "terraform-storage-rg"
  #      storage_account_name  = "terraformstatexlrwdrzs"
  #      container_name        = "tfstatefiles"
  #      key                   = "terraform-custom-vnet.tfstate"
  #    }

}


# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {

  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}

