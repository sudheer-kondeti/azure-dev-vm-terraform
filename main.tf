resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

#Virtual Network + Subnet
resource "azurerm_virtual_network" "dev_vm_vnet" {
  name = "dev-vm-vnet"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Subnet
resource "azurerm_subnet" "dev_vm_subnet" {
  name = "dev-vm-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.dev_vm_vnet.name
  address_prefixes = ["10.0.1.0/24"]
  depends_on = [azurerm_virtual_network.dev_vm_vnet]

}

# resource "azurerm_subnet" "bastion_subnet" {
#   name = "AzureBastionSubnet"
#   resource_group_name = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.dev_vm_vnet.name
#   address_prefixes = ["10.0.2.0/24"]
# }

#------------------------------
# Standard + Static public IP
#-------------------------------
resource "azurerm_public_ip" "dev_vm_ip" {
    name = "dev-vm-ip"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
  
}
#Network Interface
resource "azurerm_network_interface" "dev_vm_nic" {
    name = "dev-vm-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.dev_vm_subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.dev_vm_ip.id
    }

    depends_on = [azurerm_subnet.dev_vm_subnet, azurerm_public_ip.dev_vm_ip]

}

#---------------------------------
# NSG(via RDP)
#------------------------------------
resource "azurerm_network_security_group" "dev_vm_nsg" {
  name = "dev-vm-nsg"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name = "RDP"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "dev_vm_assoc" {
  network_interface_id = azurerm_network_interface.dev_vm_nic.id
  network_security_group_id = azurerm_network_security_group.dev_vm_nsg.id
}

#Windows VM
resource "azurerm_windows_virtual_machine" "dev_vm" {
    name = var.vm_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_D4s_v5"
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = [azurerm_network_interface.dev_vm_nic.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "MicrosoftWindowsDesktop"
      offer = "Windows-11"
      sku = "win11-23h2-pro"
      version = "latest"
    }
    tags = {
      environment = "development"
    }
provision_vm_agent =true

#Run Powershel
custom_data = base64encode(file("${path.module}/scripts/bootstrap.ps1"))
}


locals {
  devtools_commands = join(";",[
    "Set-ExecutionPolicy Bypass -Scope Process -Force",

    "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 307",
     "iex((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
    "choco install -y git",
    "choco install -y intellijidea-community",
    "choco install -y notepad++",
    "choco install -y docker-desktop",
    "choco install -y kubernetes-cli",
    "choco install -y kubernetes-helm",
    "choco install -y azure-cli"
  ]

  )
}

#--------------------------------------------
# Custom Script Extention to install devtools
#--------------------------------------------
resource "azurerm_virtual_machine_extension" "install_devtools" {
  name = "install-devtools"
  virtual_machine_id = azurerm_windows_virtual_machine.dev_vm.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings = <<SETTINGS
  {
    "commandToExecute":"powershell -ExecutionPolicy Bypass -Command \"${local.devtools_commands}\""
    }
  SETTINGS

#   settings = <<SETTINGS
#   {
#     "fileUris": ["https://dev44.blob.core.windows.net/scripts/install-dev-tools.ps1"],
#     "commandToExecute" : "powershell -ExecutionPolicy Unrestricted -File install-dev-tools.ps1"
#   }
#   SETTINGS
}

#Bastion Setup
# resource "azurerm_public_ip" "bastion_ip" {
#     name = "bastion-ip"
#     location = azurerm_resource_group.rg.location
#     resource_group_name = azurerm_resource_group.rg.name
#     allocation_method = "Static"
#     sku = "Standard"
# }

# resource "azurerm_bastion_host" "dev_bastion" {
#     name = "dev-bastion"
#     location = azurerm_resource_group.rg.location
#     resource_group_name = azurerm_resource_group.rg.name
#     ip_configuration {
#       name = "configuration"
#       subnet_id = azurerm_subnet.bastion_subnet.id
#       public_ip_address_id = azurerm_public_ip.bastion_ip.id
#     }
# }

# #VPN Gateway
# resource "azurerm_virtual_network_gateway" "vpn_gateway" {
#     name = "dev-vpn-gateway"
#     location = azurerm_resource_group.rg.location
#     resource_group_name = azurerm_resource_group.rg.name
#     type = "Vpn"
#     vpn_type = "RouteBased"
#     active_active = false
#     enable_bgp = false
#     sku = "VpnGw1"
#     ip_configuration {
#       name = "vpngw-ipconf"
#       public_ip_address_id = azurerm_public_ip.vpn_gateway_ip.id
#       subnet_id = azurerm_subnet.gateway_subnet.id
#     }

    # point_to_site_configuration{
    #     address_pool = ["172.16.201.0/24"]
    #     tunnel_type = ["OpenVPN"]
    #     authentication_type = ["EAPTLS"]
    #     root_certificate {
    #         name = "dev-root-cert"
    #         public_cert_data = file("certs/root_cert.cer")
    #     }
    # }
#}
