resource "azurerm_user_assigned_identity" "aks" {
  name                = "${azurerm_resource_group.i.name}-aks"
  location            = azurerm_resource_group.i.location
  resource_group_name = azurerm_resource_group.i.name
}

resource "azurerm_role_assignment" "aks_vnet" {
  scope                = azurerm_virtual_network.i.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "i" {
  name                = azurerm_resource_group.i.name
  resource_group_name = azurerm_resource_group.i.name
  location            = azurerm_resource_group.i.location

  automatic_channel_upgrade = var.kube.automatic_channel_upgrade
  node_os_channel_upgrade   = var.kube.node_os_channel_upgrade
  node_resource_group       = "${azurerm_resource_group.i.name}-nodes"
  dns_prefix                = azurerm_resource_group.i.name
  sku_tier                  = var.kube.sku_tier
  azure_policy_enabled      = false
  oidc_issuer_enabled       = false
  workload_identity_enabled = false
  local_account_disabled    = true

  default_node_pool {
    name                        = "default"
    enable_auto_scaling         = true
    min_count                   = var.kube.node_min
    max_count                   = var.kube.node_max
    vm_size                     = var.kube.node_size
    zones                       = var.kube.node_zones
    os_disk_type                = var.kube.node_disk_type
    os_disk_size_gb             = var.kube.node_disk_size
    os_sku                      = var.kube.node_os
    vnet_subnet_id              = azurerm_subnet.nodes.id
    max_pods                    = var.kube.node_pods_max
    temporary_name_for_rotation = "temp"
  }

  api_server_access_profile {
    authorized_ip_ranges     = var.kube.allowed_hosts
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.controller.id
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    service_cidr        = "172.16.0.0/16"
    pod_cidr            = "172.20.0.0/14"
    dns_service_ip      = "172.16.0.10"
    outbound_type       = "loadBalancer"
    load_balancer_sku   = "standard"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  auto_scaler_profile {
    skip_nodes_with_local_storage = false
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.kube.entra_admins
  }

  maintenance_window {
    allowed {
      day   = var.kube.maintenance_day
      hours = [0, 1, 2, 3, 4, 5, 6]
    }
  }
}
