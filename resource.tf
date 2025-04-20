
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.30.0"
    }
  }
}

provider "google" {
  project      = "storied-courier-427305-m0"
  # Configuration options
}
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  project      = "storied-courier-427305-m0"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  project      = "storied-courier-427305-m0"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
