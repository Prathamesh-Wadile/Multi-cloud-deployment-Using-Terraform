resource "google_compute_network" "multi-cloud-vpc" {
    name = "multi-cloud-vpc"
    auto_create_subnetworks = false  
}

resource "google_compute_subnetwork" "multi-cloud-subnet" {
    name = "multi-cloud-subnet"
    ip_cidr_range = "10.0.0.0/24"
    region = "us-central1"
    network = google_compute_network.multi-cloud-vpc.self_link
}

resource "google_compute_firewall" "multi-cloud-firewall" {
    name = "multi-cloud-firewall"
    network = google_compute_network.multi-cloud-vpc.self_link

    allow {
        protocol ="tcp"
        ports = ["22"]  
    }

    source_ranges = ["0.0.0.0/0"] #ur ip or company ip
}

resource "google_compute_instance" "multi-cloud-instance" {
    name = "multi-cloud-instance"
    machine_type = "f1-micro"
    
    boot_disk {
      initialize_params {
        image = "projects/debian-cloud/global/images/family/debian-10"
      }
    }

    network_interface {
        subnetwork = google_compute_subnetwork.multi-cloud-subnet.self_link
        access_config {
            // Ephemeral IP
        }
    }

    metadata = {
        ssh-keys = "adminuser:${file("C:/Users/019105/.ssh/id_rsa.pub")}"
    }
}

