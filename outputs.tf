output "external_ip" {
  value = google_compute_instance.instancia_final.network_interface.0.access_config.0.nat_ip
}

