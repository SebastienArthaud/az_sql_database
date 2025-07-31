variable "environment" {
  type        = string
  description = "Environnement de déploiement des ressources"
}

variable "server_name" {
  type        = string
  description = "Nom de l'App Service Plan"
}

variable "location" {
  type        = string
  description = "Localisation"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Nom du Resource Group"
}

variable "sql_server_tags" {
  type        = map(string)
  default     = {}
  description = "Map de tags"
}

variable "db_version" {
  type        = string
  description = "Version SQL"
}

variable "administrator_login" {
  type        = string
  description = "Login admin"
  default     = null
}

variable "administrator_password" {
  type        = string
  description = "Mot de passe admin (ou à récupérer dans KeyVault)"
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Autoriser l'accès public ?"
  default     = false
}

variable "identity_type" {
  type        = string
  description = "Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées)"
  default     = "SystemAssigned"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "ID de l'UAI"
  default     = null
}


variable "private_endpoint_subnet_name" {
  type        = string
  description = "Subnet ou sera déployé le private endpoint"
  default     = null
}

variable "private_endpoint_virtual_network_name" {
  type        = string
  description = "VNET ou sera déployé le private endpoint"
  default     = null
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint"
  default     = null
}


variable "entra_id_authentication" {
  type        = bool
  description = "Définis si l'authentification Entra sera activée ou non"
  default     = false
}

variable "entra_admin_login_username" {
  type        = string
  description = "The login username of the Azure AD Administrator of this SQL Server"
  default     = null
}

variable "entra_admin_object_id" {
  type        = string
  description = "The login ObjectId of the Azure AD Administrator of this SQL Server"
  default     = null
}

variable "entra_admin_tenant_id" {
  type        = string
  description = "The tenant id of the Azure AD Administrator of this SQL Server."
  default     = null
}

variable "azuread_authentication_only" {
  type        = bool
  description = "Specifies whether only AD Users and administrators (e.g. azuread_administrator[0].login_username) can be used to login, or also local database users (e.g. administrator_login). When true, the administrator_login and administrator_login_password properties can be omitted."
  default     = false
}

variable "sql_databases" {
  type = map(object({
    database_name        = string
    collation            = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    geo_backup_enabled   = optional(bool, false)
    max_size_gb          = number
    sku_name             = string
    storage_account_type = optional(string, "Local")
    database_tags        = optional(map(string), {})
  }))
  description = "MAP comportant tous les databases de ce SQL Server"
  default     = {}
}


variable "create_elastic_pool" {
  type        = bool
  description = "permet de définir la création d'un elastic pool ou non"
  default     = false
}

variable "elasticpool_name" {
  type        = string
  description = "Nom de l'elastic pool si il y en a un"
  default     = null
}

variable "elasticpool_max_size_gb" {
  type        = number
  description = "The max data size of the elastic pool in gigabytes."
  default     = 10
}

variable "elasticpool_sku_name" {
  type        = string
  description = "Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based or DTU based. Possible DTU based values are BasicPool, StandardPool, PremiumPool while possible vCore based values are GP_Gen4, GP_Gen5, GP_Fsv2, GP_DC, BC_Gen4, BC_Gen5, BC_DC, HS_PRMS, HS_MOPRMS, or HS_Gen5."
  default     = "GP_Gen5"
}

variable "elasticpool_capacity" {
  type        = number
  description = " The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration:\nhttps://docs.microsoft.com/azure/sql-database/sql-database-vcore-resource-limits-elastic-pools or\nhttps://docs.microsoft.com/azure/sql-database/sql-database-dtu-resource-limits-elastic-pools"
  default     = 2
}

variable "elasticpool_tier_name" {
  type        = string
  description = "The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale."
  default     = "GeneralPurpose"
}

variable "elasticpool_per_database_max_settings" {
  type        = number
  description = "The minimum capacity all databases are guaranteed."
  default     = 2
}

variable "elasticpool_per_database_min_settings" {
  type        = number
  description = "The minimum capacity all databases are guaranteed."
  default     = 1
}

variable "firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au MySQL Flexible server (non recommandé),
    AJoutez l'objet suivant :
    "Azure_Services" = {
      start_ip_address = 'O.O.O.O/O'
      end_ip_address   = 'O.O.O.O/O'
    }
  DESCRIPTION
  default     = {}
}


variable "subnet_ids_to_allow" {
  type        = list(string)
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet !
  DESCRIPTION
  default     = []
}


variable "elastic_pools" {
  type = map(object({
    suffix                    = string
    max_size_gb               = optional(number, 10)
    sku_name                  = optional(string, "GP_Gen5")
    capacity                  = optional(number, 2)
    tier_name                 = optional(string, "GeneralPurpose")
    per_database_max_settings = optional(number, 2)
    per_database_min_settings = optional(number, 1)
  }))
  description = "correspond a l'elastic pool aux elastics pool à créer si besoin"
  default     = {}
}