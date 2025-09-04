terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

# Provider Azure
provider "azurerm" {
  features {}
  subscription_id = data.vault_generic_secret.azure.data["subscription_id"]
}

# Provider Vault
provider "vault" {  
}

# Lecture des secrets Jenkins dans Vault (KV v2)
data "vault_kv_secret_v2" "jenkins" {
  mount = "secret"       # le path où ton KV est monté dans Vault
  name  = "jenkins"      # le chemin du secret (ex: secret/data/jenkins)
}

# Lecture des secrets Azure dans Vault (KV v2)
data "vault_kv_secret_v2" "azure" {
  mount = "secret"       # pareil, même KV mount
  name  = "azure"        # ex: secret/data/azure
}