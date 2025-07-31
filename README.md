<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_SQL_private_endpoint"></a> [SQL\_private\_endpoint](#module\_SQL\_private\_endpoint) | ../azure_private_endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.sql_databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_elasticpool.elasticpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_virtual_network_rule.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | Version SQL | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environnement de déploiement des ressources | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nom du Resource Group | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Nom de l'App Service Plan | `string` | n/a | yes |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | Login admin | `string` | `null` | no |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | Mot de passe admin (ou à récupérer dans KeyVault) | `string` | `null` | no |
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Specifies whether only AD Users and administrators (e.g. azuread\_administrator[0].login\_username) can be used to login, or also local database users (e.g. administrator\_login). When true, the administrator\_login and administrator\_login\_password properties can be omitted. | `bool` | `false` | no |
| <a name="input_create_elastic_pool"></a> [create\_elastic\_pool](#input\_create\_elastic\_pool) | permet de définir la création d'un elastic pool ou non | `bool` | `false` | no |
| <a name="input_elastic_pools"></a> [elastic\_pools](#input\_elastic\_pools) | correspond a l'elastic pool aux elastics pool à créer si besoin | <pre>map(object({<br/>    suffix                    = string<br/>    max_size_gb               = optional(number, 10)<br/>    sku_name                  = optional(string, "GP_Gen5")<br/>    capacity                  = optional(number, 2)<br/>    tier_name                 = optional(string, "GeneralPurpose")<br/>    per_database_max_settings = optional(number, 2)<br/>    per_database_min_settings = optional(number, 1)<br/>  }))</pre> | `{}` | no |
| <a name="input_elasticpool_capacity"></a> [elasticpool\_capacity](#input\_elasticpool\_capacity) | The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration:<br/>https://docs.microsoft.com/azure/sql-database/sql-database-vcore-resource-limits-elastic-pools or<br/>https://docs.microsoft.com/azure/sql-database/sql-database-dtu-resource-limits-elastic-pools | `number` | `2` | no |
| <a name="input_elasticpool_max_size_gb"></a> [elasticpool\_max\_size\_gb](#input\_elasticpool\_max\_size\_gb) | The max data size of the elastic pool in gigabytes. | `number` | `10` | no |
| <a name="input_elasticpool_name"></a> [elasticpool\_name](#input\_elasticpool\_name) | Nom de l'elastic pool si il y en a un | `string` | `null` | no |
| <a name="input_elasticpool_per_database_max_settings"></a> [elasticpool\_per\_database\_max\_settings](#input\_elasticpool\_per\_database\_max\_settings) | The minimum capacity all databases are guaranteed. | `number` | `2` | no |
| <a name="input_elasticpool_per_database_min_settings"></a> [elasticpool\_per\_database\_min\_settings](#input\_elasticpool\_per\_database\_min\_settings) | The minimum capacity all databases are guaranteed. | `number` | `1` | no |
| <a name="input_elasticpool_sku_name"></a> [elasticpool\_sku\_name](#input\_elasticpool\_sku\_name) | Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based or DTU based. Possible DTU based values are BasicPool, StandardPool, PremiumPool while possible vCore based values are GP\_Gen4, GP\_Gen5, GP\_Fsv2, GP\_DC, BC\_Gen4, BC\_Gen5, BC\_DC, HS\_PRMS, HS\_MOPRMS, or HS\_Gen5. | `string` | `"GP_Gen5"` | no |
| <a name="input_elasticpool_tier_name"></a> [elasticpool\_tier\_name](#input\_elasticpool\_tier\_name) | The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. | `string` | `"GeneralPurpose"` | no |
| <a name="input_entra_admin_login_username"></a> [entra\_admin\_login\_username](#input\_entra\_admin\_login\_username) | The login username of the Azure AD Administrator of this SQL Server | `string` | `null` | no |
| <a name="input_entra_admin_object_id"></a> [entra\_admin\_object\_id](#input\_entra\_admin\_object\_id) | The login ObjectId of the Azure AD Administrator of this SQL Server | `string` | `null` | no |
| <a name="input_entra_admin_tenant_id"></a> [entra\_admin\_tenant\_id](#input\_entra\_admin\_tenant\_id) | The tenant id of the Azure AD Administrator of this SQL Server. | `string` | `null` | no |
| <a name="input_entra_id_authentication"></a> [entra\_id\_authentication](#input\_entra\_id\_authentication) | Définis si l'authentification Entra sera activée ou non | `bool` | `false` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au MySQL Flexible server (non recommandé),<br/>    AJoutez l'objet suivant :<br/>    "Azure\_Services" = {<br/>      start\_ip\_address = 'O.O.O.O/O'<br/>      end\_ip\_address   = 'O.O.O.O/O'<br/>    } | <pre>map(object({<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées) | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | Localisation | `string` | `"westeurope"` | no |
| <a name="input_private_endpoint_subnet_name"></a> [private\_endpoint\_subnet\_name](#input\_private\_endpoint\_subnet\_name) | Subnet ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_private_endpoint_virtual_network_name"></a> [private\_endpoint\_virtual\_network\_name](#input\_private\_endpoint\_virtual\_network\_name) | VNET ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Autoriser l'accès public ? | `bool` | `false` | no |
| <a name="input_sql_databases"></a> [sql\_databases](#input\_sql\_databases) | MAP comportant tous les databases de ce SQL Server | <pre>map(object({<br/>    database_name        = string<br/>    collation            = optional(string, "SQL_Latin1_General_CP1_CI_AS")<br/>    geo_backup_enabled   = optional(bool, false)<br/>    max_size_gb          = number<br/>    sku_name             = string<br/>    storage_account_type = optional(string, "Local")<br/>    database_tags        = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_sql_server_tags"></a> [sql\_server\_tags](#input\_sql\_server\_tags) | Map de tags | `map(string)` | `{}` | no |
| <a name="input_subnet_ids_to_allow"></a> [subnet\_ids\_to\_allow](#input\_subnet\_ids\_to\_allow) | Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet ! | `list(string)` | `[]` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | ID de l'UAI | `string` | `null` | no |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elastic_pool_id"></a> [elastic\_pool\_id](#output\_elastic\_pool\_id) | n/a |
| <a name="output_sql_server_id"></a> [sql\_server\_id](#output\_sql\_server\_id) | n/a |
<!-- END_TF_DOCS -->