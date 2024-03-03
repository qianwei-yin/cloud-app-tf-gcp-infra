# VPC
resource "google_compute_network" "vpc" {
  count                           = length(var.vpc_list)
  name                            = "${var.vpc_list[count.index]}-${count.index}"
  description                     = var.vpc_description
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks
  routing_mode                    = var.vpc_routing_mode
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create
}

# Subnet - webapp
resource "google_compute_subnetwork" "subnet_webapp" {
  count                    = length(var.vpc_list)
  name                     = "${var.webapp_subnet_name_prefix}${count.index}"
  ip_cidr_range            = var.webapp_ip_cidr_range
  network                  = google_compute_network.vpc[count.index].name
  region                   = var.region
  private_ip_google_access = var.webapp_private_ip_google_access
}

# Subnet - db
resource "google_compute_subnetwork" "subnet_db" {
  count                    = length(var.vpc_list)
  name                     = "${var.db_subnet_name_prefix}${count.index}"
  ip_cidr_range            = var.db_ip_cidr_range
  network                  = google_compute_network.vpc[count.index].name
  region                   = var.region
  private_ip_google_access = var.db_private_ip_google_access
}

resource "google_compute_route" "custom_route" {
  count            = length(var.vpc_list)
  name             = "${var.custom_route_name_prefix}${count.index}"
  network          = google_compute_network.vpc[count.index].name
  dest_range       = var.custom_route_dest_range
  next_hop_gateway = var.custom_route_next_hop_gateway
}
