terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.14.9"
}

variable "suscription_id" {
    type = string
    description = "Azure subscription id"
}

variable "sqladmin_username" {
    type = string
    description = "Administrator username for server"
}

variable "sqladmin_password" {
    type = string
    description = "Administrator password for server"
    sensitive = true
}

provider "azurerm" {
  features {}
  subscription_id = var.suscription_id
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 100
  max = 999
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "upt-arg-${random_integer.ri.result}"
  location = "eastus"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "upt-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "upt-awa-${random_integer.ri.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  depends_on            = [azurerm_service_plan.appserviceplan]
  https_only            = true
  
  site_config {
    minimum_tls_version = "1.2"
    always_on = false
    
    application_stack {
      docker_image_name = "patrickcuadros/shorten:latest"
      docker_registry_url = "https://index.docker.io"      
    }
  }

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}

resource "azurerm_mssql_server" "sqlsrv" {
  name                         = "upt-dbs-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sqladmin_username
  administrator_login_password = var.sqladmin_password
  minimum_tls_version          = "1.2"
  public_network_access_enabled = true

  azuread_administrator {
    login_username = var.sqladmin_username
    object_id      = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_mssql_firewall_rule" "sqlaccessrule" {
  name             = "PublicAccess"
  server_id        = azurerm_mssql_server.sqlsrv.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_mssql_database" "sqldb" {
  name      = "shorten"
  server_id = azurerm_mssql_server.sqlsrv.id
  sku_name  = "Free"
  
  threat_detection_policy {
    state                      = "Enabled"
    email_account_admins       = "Enabled"
    retention_days             = 7
  }

  long_term_retention_policy {
    weekly_retention  = "P1W"
    monthly_retention = "P1M"
    yearly_retention  = "P1Y"
    week_of_year      = 1
  }
}

resource "azurerm_mssql_server_transparent_data_encryption" "sqlencryption" {
  server_id = azurerm_mssql_server.sqlsrv.id
}

output "webapp_url" {
  value = "https://${azurerm_linux_web_app.webapp.default_hostname}"
  description = "URL de la aplicación web"
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sqlsrv.fully_qualified_domain_name
  description = "FQDN del servidor SQL"
}
