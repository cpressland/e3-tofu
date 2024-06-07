terraform {
  required_version = ">= 1.7.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.107.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2"
    }
  }
}
locals {
  entra_groups = {
    for group_name in distinct(data.azuread_groups.all.display_names) : group_name =>
    data.azuread_groups.all.object_ids[index(data.azuread_groups.all.display_names, group_name)]
  }
}

data "azuread_groups" "all" {
  return_all = true
}

module "cluster" {
  source = "./modules/cluster"
  config = {
    name     = "e3-cluster"
    location = "uksouth"
    cidr     = "10.0.0.0/20"
  }
  kube = {
    allowed_hosts = ["217.169.3.233", "81.2.102.194", "81.2.99.144/29"] // cpressland.io hosts
    entra_admins  = [local.entra_groups["Kubernetes Admins"]]
  }
}
