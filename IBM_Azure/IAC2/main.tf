# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.56.0"
    }
  }
} 

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
#Sert VAriables 

locals {
  virtual_machine_name = "${var.prefix}-vm"
  
}

# Create a resource group
resource "azurerm_resource_group" "RG"{
  name     = "${var.prefix}-RG"
  location = "${var.location}"
  
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "VNET"{
  name                = "${var.prefix}-vnet"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  location            = "${azurerm_resource_group.RG.location}"
  address_space       = ["10.0.0.0/16"]
}
#Creat Public IP
resource "azurerm_public_ip" "PIP"{
  name                = "${var.prefix}-publicip-${count.index}"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  location            = "${azurerm_resource_group.RG.location}"
  allocation_method   = "Static"
  count                = 2
}
#Create Subnet
resource "azurerm_subnet"  "Subnet1"{
  name                 = "internal"
  virtual_network_name = "${azurerm_virtual_network.VNET.name}"
  resource_group_name  = "${azurerm_resource_group.RG.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

#create Network INterface 
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.RG.name}"
  count                = 2
  

  ip_configuration {
    name                                    = "ipconfig${count.index}"
    subnet_id                               = "${azurerm_subnet.Subnet1.id}"
    private_ip_address_allocation           = "Dynamic"
    public_ip_address_id                    = azurerm_public_ip.PIP[count.index].id
  }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.RG.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.RG.name}"
    location                    = "${var.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

}

#create VM

resource "azurerm_linux_virtual_machine" "VMs" {
  name                  = "${var.prefix}-vm-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.RG.name}"
  size                  = "Standard_DS1_v2"
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  count                 = 2
  
  admin_username        = "azureuser"
  disable_password_authentication = true

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  #delete_os_disk_on_termination = true

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }

  os_disk {
    name                   = "${var.prefix}-osdisk-${count.index}"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = 128
  }

  admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }


/*
  os_profile_linux_config {
    disable_password_authentication = false
  }
  */
 

}