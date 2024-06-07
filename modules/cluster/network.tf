resource "azurerm_virtual_network" "i" {
  name                = azurerm_resource_group.i.name
  location            = azurerm_resource_group.i.location
  resource_group_name = azurerm_resource_group.i.name
  address_space       = [var.config.cidr]
}

resource "azurerm_subnet" "nodes" {
  name                 = "AzureKubernetesService"
  resource_group_name  = azurerm_resource_group.i.name
  virtual_network_name = azurerm_virtual_network.i.name
  address_prefixes     = [cidrsubnet(var.config.cidr, 2, 0)] // 10.0.0.0/22 (1024 Hosts)
  service_endpoints = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage",
  ]
  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_subnet" "controller" {
  name                 = "AzureKubernetesServiceController"
  resource_group_name  = azurerm_resource_group.i.name
  virtual_network_name = azurerm_virtual_network.i.name
  address_prefixes     = [cidrsubnet(var.config.cidr, 4, 4)] // 10.0.4.0/24

  lifecycle {
    ignore_changes = [delegation]
  }
}
