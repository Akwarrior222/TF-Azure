# General
resource_group_name   = "migrationgroup"
location              = "Central India"
project_name          = "demo"
project_prefix        = "skcn"
instance_name         = "test-vm"

# Networking
subnet_id             = "/subscriptions/9ab7ab94-d8d0-4de5-b31f-3ce088b0423b/resourceGroups/migrationgroup/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
private_ip_address    = "10.0.1.10"


# Public IP Association
associate_public_ip   = true

# VM Details
vm_size               = "Standard_D2s_v3"
vm_zone               = null  # Let random selection happen
admin_username        = "azureuser"

# SSH Keys
machine_ssh_keys = [
  {
    username = "azureuser"
    key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0XknB2FkeAtF2IeyMtiGl5EsgruJmoqgtzuV0a0r2b5GXvksvk5AaEFt0TZNDxlKk5raarIE+TKyuXvBAolxiDRdKxVX/DaMzVUnge6rZhwGWRSZd3f2tRnaxtyooYBFbN6EcLlaIzK2eMdm4SBcQa6RVJV5aquybUhoJjc9gwidVVr+Jv8TTpnv1dH2/4m6j1kWjPBE1zO5AfTiskRfZnwkQ0+LlMfTPfy6RkZMP6WjP/fICWwwLMjngNf9K8LO6qsFhIMj4UQg3FxL0mVCiQy20UWCAN0ZNHGAR/sYEvoI4PmTsoFOgobRIqy4VFg5ss51kpddAybNlp2Wqx+DcqQYJSutfWT7N5x8yagR6uKohCyfnn80JBdoMmlnyNddBMsRK2v/tc1WZf+YsKL81/lHyGUfBzTcOjoZreop7CqhD8obDJz+k0XAqttOSx+CaNFuLXf1aiGjmouiZLz8xgwdQa07YNhwWLuob/7ZFOZQN5A7AUzOoyR3vIJbdKuE= generated-by-azure"  # Replace with your actual public SSH key
  }
]

# Image Reference
image_publisher       = "Canonical"
image_offer           = "UbuntuServer"
image_sku             = "22_04-lts-gen1"


# Startup script
# startup_script        = <<-EOT
# #!/bin/bash
# echo "Hello from Terraform VM" > /var/tmp/hello.txt
# EOT

# Identity and IAM
create_service_account = true
iam_roles = [
  "Contributor",
  "Reader"
]

# Tags
tags = {
  Environment = "Dev"
  Project     = "Terraform-VM-Deployment"
}

