resource "google_compute_network" "custom_vpc_tf" {
  count                           = length(var.vpc_list)
  name                            = var.vpc_list[count.index]
  description                     = var.vpc_description
  auto_create_subnetworks         = var.vpc_auto_create_subnetworks
  routing_mode                    = var.vpc_routing_mode
  delete_default_routes_on_create = var.vpc_delete_default_routes_on_create
}

resource "google_compute_subnetwork" "subnet_webapp" {
  count         = length(var.vpc_list)
  name          = "webapp${count.index == 0 ? "" : count.index}"
  ip_cidr_range = var.webapp_ip_cidr_range
  network       = google_compute_network.custom_vpc_tf[count.index].name
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_db" {
  count         = length(var.vpc_list)
  name          = "db${count.index == 0 ? "" : count.index}"
  ip_cidr_range = var.db_ip_cidr_range
  network       = google_compute_network.custom_vpc_tf[count.index].name
  region        = var.region
}

resource "google_compute_route" "custom_route" {
  count            = length(var.vpc_list)
  name             = "custom-route${count.index}"
  network          = google_compute_network.custom_vpc_tf[count.index].name
  dest_range       = var.custom_route_dest_range
  next_hop_gateway = var.custom_route_next_hop_gateway
}
