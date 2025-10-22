
locals {
  private_endpoint_name = "PEP-EUR-FR-${var.environment}-${upper(var.server_name)}"
}

resource "azurerm_mssql_server" "sql_server" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.db_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? toset([1]) : toset([])
    content {
      type         = var.identity_type
      identity_ids = [var.user_assigned_identity_id]
    }
  }

  dynamic "azuread_administrator" {
    for_each = var.entra_id_authentication == true ? toset([1]) : toset([])
    content {
      login_username              = var.entra_admin_login_username
      object_id                   = var.entra_admin_object_id
      tenant_id                   = var.entra_admin_tenant_id
      azuread_authentication_only = var.azuread_authentication_only
    }
  }

  primary_user_assigned_identity_id = var.identity_type == "UserAssigned" ? var.user_assigned_identity_id : null
  tags                              = var.sql_server_tags
}

resource "azurerm_mssql_elasticpool" "elasticpool" {
  for_each            = var.create_elastic_pool == true && var.elastic_pools != {} ? var.elastic_pools : {}
  name                = "sqlpool-${var.server_name}-${each.value.suffix}"
  server_name         = azurerm_mssql_server.sql_server.name
  location            = azurerm_mssql_server.sql_server.location
  resource_group_name = var.resource_group_name
  max_size_gb         = each.value.max_size_gb
  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
    tier     = each.value.tier_name
  }
  per_database_settings {
    max_capacity = each.value.per_database_max_settings
    min_capacity = each.value._per_database_min_settings
  }

}


resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  for_each         = var.firewall_rules != {} ? var.firewall_rules : {}
  name             = each.key
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_virtual_network_rule" "example" {
  for_each  = var.subnet_ids_to_allow != [] ? toset(var.subnet_ids_to_allow) : toset([])
  name      = reverse(split("/", each.key))[0]
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = each.key
}


module "SQL_private_endpoint" {
  count                               = var.public_network_access_enabled == false || var.create_private_endpoint == true ? 1 : 0
  source                              = "../azure_private_endpoint"
  private_endpoint_name               = local.private_endpoint_name
  subnet_name                         = var.private_endpoint_subnet_name
  virtual_network_name                = var.private_endpoint_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  resource_group_name                 = var.resource_group_name
  private_connection_resource_id      = azurerm_mssql_server.sql_server.id
  subresourceType                     = "sqlServer"
}


resource "azurerm_mssql_database" "sql_databases" {
  for_each             = var.sql_databases
  name                 = each.value.database_name
  server_id            = azurerm_mssql_server.sql_server.id
  collation            = each.value.collation
  geo_backup_enabled   = each.value.geo_backup_enabled
  max_size_gb          = each.value.max_size_gb
  sku_name             = each.value.sku_name == "ElasticPool" && var.create_elastic_pool == false ? "GP_Gen5_2" : each.value.sku_name != "ElasticPool" && var.create_elastic_pool == true ? "ElasticPool" : each.value.sku_name
  elastic_pool_id      = var.create_elastic_pool == true ? azurerm_mssql_elasticpool.elasticpool[0].id : null
  storage_account_type = each.value.storage_account_type
  tags                 = each.value.database_tags
}


resource "azurerm_key_vault_secret" "mysql_admin_password" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-Admin-Password"
  value        = var.administrator_password
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_admin_login" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-Admin-login"
  value        = var.administrator_login
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_fqdn" {
  count        = var.register_mysqlinfos_to_key_vault == true ? 1 : 0
  name         = "MySQL-fqdn"
  value        = azurerm_mssql_server.sql_server.fully_qualified_domain_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_database" {
  for_each     = var.sql_databases != {} && var.register_mysqlinfos_to_key_vault == true ? var.sql_databases : {}
  name         = replace("MySQL-database-${each.value.database_name}", "_", "-")
  value        = each.value.database_name
  key_vault_id = var.key_vault_id
}

