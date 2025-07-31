output "sql_server_id" {
  value = azurerm_mssql_server.sql_server.id
}

output "elastic_pool_id" {
  value = var.create_elastic_pool == true ? azurerm_mssql_elasticpool.elasticpool[0].id : null
}
