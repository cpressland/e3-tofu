variable "config" {
  type = object({
    name     = string
    location = string
    cidr     = string
  })
}

variable "kube" {
  type = object({
    automatic_channel_upgrade = optional(string, "rapid")
    node_os_channel_upgrade   = optional(string, "NodeImage")
    sku_tier                  = optional(string, "Free")
    node_min                  = optional(number, 1)
    node_max                  = optional(number, 10)
    node_size                 = optional(string, "Standard_D4ds_v5")
    node_zones                = optional(list(string), ["1", "2", "3"])
    node_disk_type            = optional(string, "Ephemeral")
    node_disk_size            = optional(number, 128)
    node_os                   = optional(string, "AzureLinux")
    node_pods_max             = optional(number, 50)
    maintenance_day           = optional(string, "Monday")
    allowed_hosts             = list(string)
    entra_admins              = list(string)
  })
}
