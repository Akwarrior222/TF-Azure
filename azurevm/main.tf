locals {
  default_startup_script = templatefile("${path.module}/templates/userdata.sh", {
    ssh_port = var.ssh_port
  })

  startup_script = join("\n\n", [local.default_startup_script, var.custom_startup_script])

  instance_name = "${var.project_prefix}-${var.instance_name}"
}

provider "azurerm" {
  features {}
  subscription_id = "9ab7ab94-d8d0-4de5-b31f-3ce088b0423b" 
  tenant_id       = "deaef897-b598-44df-ae17-982bbdce0b3e"
  client_id       = "50613311-682c-47e2-a5ff-f9a2dbcf4978"
  client_secret   = var.client_secret
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "example-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Virtual Network and Subnet must exist or be created elsewhere
# We'll assume they are passed in as variables

# Static Public IP (conditional)
resource "azurerm_public_ip" "public_ip" {
  name                = "example-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["3"]  # Match the zone of your VM
}

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
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

data "azurerm_subscription" "primary" {}
# Assign Role to Identity
resource "azurerm_role_assignment" "identity_roles" {
  for_each            = var.create_service_account ? toset(var.iam_roles) : []
  scope               = data.azurerm_subscription.primary.id
  role_definition_name = each.key
  principal_id        = azurerm_user_assigned_identity.identity[0].principal_id
}

# VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "test-vm2"
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
    name              = "test-vm-osdisk"
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
