provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network and Subnet must exist or be created elsewhere
# We'll assume they are passed in as variables

# Static Public IP (conditional)
resource "azurerm_public_ip" "public" {
  count               = var.associate_public_ip ? 1 : 0
  name                = "${local.instance_name}-pub-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${local.instance_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address

    public_ip_address_id = var.associate_public_ip ? azurerm_public_ip.public[0].id : null
  }
}

# Random availability zone selection (optional)
resource "random_integer" "zone" {
  min = 1
  max = 3
}

# Service Principal (Optional)
resource "azurerm_user_assigned_identity" "identity" {
  count               = var.create_service_account ? 1 : 0
  name                = "${local.instance_name}-id"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Assign Role to Identity
resource "azurerm_role_assignment" "identity_roles" {
  for_each            = var.create_service_account ? toset(var.iam_roles) : []
  scope               = data.azurerm_subscription.primary.id
  role_definition_name = each.key
  principal_id        = azurerm_user_assigned_identity.identity[0].principal_id
}

# VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.instance_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  size               = var.vm_size
  zone               = var.vm_zone == null ? random_integer.zone.result : var.vm_zone
  admin_username     = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.machine_ssh_keys[0].key
  }

  os_disk {
    name              = "${local.instance_name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  custom_data = base64encode(local.startup_script)

  identity {
    type = var.create_service_account ? "UserAssigned" : "SystemAssigned"
    identity_ids = var.create_service_account ? [azurerm_user_assigned_identity.identity[0].id] : null
  }

  tags = var.tags
}
