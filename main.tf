provider "google" {
  credentials = file("./proyecto-final-gcp-410014-e3d01ae289cb.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_address" "external_ip" {
  name   = "mi-ip-externa"
  region = var.region
}

resource "google_compute_instance" "instancia_final" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.external_ip.address
    }
  }
  provisioner "local-exec" {
    command = "echo '[servidor-gcp] \n ${google_compute_instance.instancia_final.network_interface.0.access_config.0.nat_ip}' > inventory"
  }

  metadata = {
    ssh-keys = "fgonzavz:${file("ansible-prueba/ssh/id_rsa.pub")}"
  }

}
