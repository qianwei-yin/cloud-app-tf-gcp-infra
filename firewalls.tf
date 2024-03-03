resource "google_compute_firewall" "firewall_rules_inbound" {
  count   = length(var.vpc_list)
  name    = "${var.inbound_firewall_name_prefix}${count.index}"
  network = google_compute_network.vpc[count.index].name
  allow {
    protocol = "tcp"
    ports    = var.inbound_allow_tcp_ports
  }
  source_ranges = var.inbound_firewall_source_ranges
}

resource "google_compute_firewall" "firewall_rules_ssh" {
  count   = length(var.vpc_list)
  name    = "${var.ssh_firewall_name_prefix}${count.index}"
  network = google_compute_network.vpc[count.index].name
  allow {
    protocol = "tcp"
    ports    = var.ssh_allow_tcp_ports
  }
  source_ranges = var.ssh_firewall_source_ranges
}
