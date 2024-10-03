resource "azurerm_resource_group" "rg" {
  name     = "webjobs-linux-rg"
  location = "West Europe"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "webjobs-linux-sp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "webjobs-linux-web-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    always_on = true

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "AzureWebJobsStorage"                 = azurerm_storage_account.storage.primary_connection_string
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
  }
}

resource "azurerm_linux_web_app" "web_app_container" {
  name                = "webjobs-linux-web-app-container"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    always_on                               = true
    container_registry_use_managed_identity = true

    application_stack {
      docker_registry_url = "https://${azurerm_container_registry.registry.login_server}"
      docker_image_name   = "webjob-linux-docker:latest"
    }
  }

  app_settings = {
    "AzureWebJobsStorage"                 = azurerm_storage_account.storage.primary_connection_string
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "WEBSITES_PORT"                       = 8080
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "webjobslinuxstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "queue" {
  name                 = "webjobs-linux-queue"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_container_registry" "registry" {
  name                = "webjobslinuxacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr_pule_role_assignment" {

  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.registry.id
  principal_id         = azurerm_linux_web_app.web_app_container.identity.0.principal_id
}
