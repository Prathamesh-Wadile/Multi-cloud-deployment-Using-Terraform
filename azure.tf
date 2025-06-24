resource "azurerm_resource_group" "multi-cloud-rg" {
    name = "multi-cloud-rg"
    location = "East-us"
}

resource "azurerm_virtual_network" "multi-cloud-vnet" {
    name = "multi-cloud-vnet"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.multi-cloud-rg.location
    resource_group_name = azurerm_resource_group.multi-cloud-rg.name 
}

resource "azurerm_subnet" "multi-cloud-subnet" {
    name = "multi-cloud-subnet"
    resource_group_name = azurerm_resource_group.multi-cloud-rg.name
    virtual_network_name = azurerm_virtual_network.multi-cloud-vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "multi-cloud-nic" {
    name = "multi-cloud-nic"
    location = azurerm_resource_group.multi-cloud-rg.location
    resource_group_name = azurerm_resource_group.multi-cloud-rg.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.multi-cloud-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.multi-cloud-pip.id
    }     
}

resource "azurerm_public_ip" "multi-cloud-pip" {
    name = "multi-cloud-pip"
    location = azurerm_resource_group.multi-cloud-rg.location
    resource_group_name = azurerm_resource_group.multi-cloud-rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "multi-cloud-vm" {
    name = "multi-cloud-vm"
    location = azurerm_resource_group.multi-cloud-rg.location
    resource_group_name = azurerm_resource_group.multi-cloud-rg.name
    network_interface_ids = [azurerm_network_interface.multi-cloud-nic.id]
    size = "Standard_B1s"

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS" 
        version = "latest"
    }

    computer_name = "multi-cloud-vm"
    admin_username = "adminuser"

    admin_ssh_key {
        username = "adminuser"
        public_key = file("C:/Users/019105/.ssh/id_rsa.pub")
    }

    disable_password_authentication = true
}