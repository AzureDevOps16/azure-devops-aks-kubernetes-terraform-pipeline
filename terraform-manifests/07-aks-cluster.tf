resource "azurerm_kubernetes_cluster" "aks_cluster" {
  #  azurerm_resource_group.aks_rg.name, location comes from 03-resource-group.tf file
  name = "${azurerm_resource_group.aks_rg.name}-cluster"
  location = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix = "${azurerm_resource_group.aks_rg.name}-cluster"
  #  data.azurerm_kubernetes_service_versions.current.latest_version comes from 04-aks-version-datasource.tf
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"


  default_node_pool {
    #    we can give any name we want
    #    name = "default"
    name       = "systempool"
    #    node count is not required when you enabled the autoscaling and min and max node count
    #    node_count = 1
    vm_size    = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    #    zones {1,2,3}
    zones = [1]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type           = "VirtualMachineScaleSets"
    node_labels = {
      #      all these are our choices
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      #      all these are our choices
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }    
  }

# Identity (System Assigned or Service Principal)
  identity { type = "SystemAssigned" }

# Add On Profiles
#  addon_profile {
#    azure_policy { enabled = true }
#    oms_agent {
#      enabled                    = true
#      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
#    }
#  }

# RBAC and Azure AD Integration Block
#  This got change now see the new one below
#role_based_access_control {
#  enabled = true
#  azure_active_directory {
#    managed                = true
#    admin_group_object_ids = [azuread_group.aks_administrators.id]
#  }
#}

  #  RBAC and Azure AD Integration Block
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed = true
    #    you will get this from 06-aks-administrators-azure-ad.tf
    admin_group_object_ids = [azuread_group.aks_administrators.id]
  }

# Windows Admin Profile
windows_profile {
  admin_username = var.windows_admin_username
  admin_password = var.windows_admin_password
}

# Linux Profile
linux_profile {
  admin_username = "ubuntu"
  ssh_key {
      key_data = file(var.ssh_public_key)
  }
}

# Network Profile
network_profile {
#  load_balancer_sku = "Standard"
  load_balancer_sku = "basic"
  network_plugin = "azure"
}

# AKS Cluster Tags 
tags = {
  Environment = var.environment
}


}