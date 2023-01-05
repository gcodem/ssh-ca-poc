# Create a Google Cloud Compute Engine network
resource "google_compute_network" "my_network" {
  name                    = var.network_name
  project                 = google_project.my_project.project_id
  auto_create_subnetworks = true
}

# Create a Google Cloud Compute Engine firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.my_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Create a Google Cloud Compute Engine instance template
resource "google_compute_instance_template" "my_template" {
  name = "my-template"
  machine_type = var.machine_type
  network_interface {
    network = google_compute_network.my_network.name
  }
  metadata = {
    ssh-keys = var.ssh_key
  }
  disk {
    image  = "ubuntu-os-cloud/ubuntu-2004-focal-v20221210"
    size   = 20
    type   = "pd-standard"
    delete_protection = false
  }
}

# Create multiple Google Cloud Compute Engine instances based on the instance template
resource "google_compute_instance" "vm" {
  count       = var.num_vms
  name        = "vm-${count.index}"
  project     = google_project.my_project.project_id
  zone        = var.zone
  instance_template = google_compute_instance_template.my_template.self_link
}