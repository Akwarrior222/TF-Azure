# PUBLIC: Allow all inbound from anywhere
resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.proj_prefix}-public-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-All-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# OFFICE: Allow inbound TCP 121 from office IPs
resource "azurerm_network_security_group" "office_nsg" {
  name                = "${var.proj_prefix}-office-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-TCP-121-From-Office"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "121"
    source_address_prefixes    = var.office_ip_list
    destination_address_prefix = "*"
  }
}

# IAP: Allow inbound TCP 121 and 22 from IAP IP range
resource "azurerm_network_security_group" "iap_nsg" {
  name                = "${var.proj_prefix}-iap-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-TCP-121"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "121"
    source_address_prefix      = "35.235.240.0/20"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-TCP-22"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "35.235.240.0/20"
    destination_address_prefix = "*"
  }
}
