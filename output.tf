output "azurerm_private_ip" {
 value = azurerm_linux_virtual_machine.multi-cloud-vm.private_ip_address
 description = "The private IP address of the Azure VM"  
}

output "gcp_instance_public_ip" {
 value = google_compute_instance.multi-cloud-instance.network_interface[0].access_config[0].nat_ip
 description = "The public IP address of the GCP instance"
}

output "gcp_instance_private_ip" {
    value = google_compute_instance.multi-cloud-instance.network_interface[0].network_ip
    description = "The private IP address of the GCP instance"
}

output "aws_instance_public_ip" {
    value = aws_instance.multi-cloud-instance.public_ip
    description = "The public IP address of the AWS instance"
}

output "aws_instance_private_ip" {
    value = aws_instance.multi-cloud-instance.private_ip
    description = "The private IP address of the AWS instance"
}