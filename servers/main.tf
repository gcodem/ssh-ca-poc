resource "google_compute_network" "vpc_network" {
  name = var.network_name
}

resource "google_compute_instance" "vm" {
  name         = "vm-${count.index + 1}"
  metadata_startup_script = file("servers-script.sh")
  count        = var.vm_count
  machine_type = var.machine_type
  tags         = ["demo-vm-instance"]

  # Use the specified image
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  metadata = {
    ssh-keys = var.ssh_key
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

}


resource "google_compute_firewall" "ssh-rule" {
  name    = "demo-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22", "8200", "8201"]
  }
  target_tags   = ["demo-vm-instance"]
  source_ranges = ["0.0.0.0/0"]
}

