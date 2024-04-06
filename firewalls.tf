# resource "google_compute_firewall" "firewall_rules_inbound" {
#   count   = length(var.vpc_list)
#   name    = "${var.inbound_firewall_name_prefix}${count.index}"
#   network = google_compute_network.vpc[count.index].name
#   allow {
#     protocol = "tcp"
#     ports    = var.inbound_allow_tcp_ports
#   }
#   source_ranges = var.inbound_firewall_source_ranges
# }

resource "google_compute_firewall" "firewall_rules_allow_proxy" {
  count = length(var.vpc_list)
  name  = "${var.allow_proxy_firewall_name_prefix}${count.index}"
  allow {
    protocol = "tcp"
    ports    = var.allow_proxy_allow_tcp_ports
  }
  network       = google_compute_network.vpc[count.index].name
  source_ranges = [var.proxy_only_ip_cidr_range]
  target_tags   = [var.firewall_target_tag]
}

# allows all TCP traffic from the Google Cloud health checking systems (in 130.211.0.0/22 and 35.191.0.0/16).
resource "google_compute_firewall" "firewall_rules_allow_health_check" {
  count = length(var.vpc_list)
  name  = "${var.allow_health_check_firewall_name_prefix}${count.index}"
  allow {
    protocol = "tcp"
  }
  network       = google_compute_network.vpc[count.index].name
  source_ranges = var.allow_health_check_firewall_source_ranges
  target_tags   = [var.firewall_target_tag]
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
