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

resource "google_compute_firewall" "firewall_rules" {
  count   = length(var.vpc_list)
  name    = "firewall${count.index}"
  network = google_compute_network.custom_vpc_tf[count.index].name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = var.allow_tcp_ports
  }
  source_ranges = var.firewall_source_ranges
}

resource "google_compute_firewall" "firewall_rules_allow_ssh" {
  count   = length(var.vpc_list)
  name    = "firewall-allow-ssh${count.index}"
  network = google_compute_network.custom_vpc_tf[count.index].name
  allow {
    protocol = "tcp"
    ports    = var.allow_ssh_tcp_ports
  }
  source_ranges = var.firewall_allow_ssh_source_ranges
}


resource "google_compute_instance" "instance-from-custom-image" {
  count = length(var.vpc_list)
  boot_disk {
    auto_delete = true
    device_name = "${var.vm_instance_name}-${count.index == 0 ? "" : count.index}"

    initialize_params {
      image = "projects/${var.project_id}/global/images/csye6225-qy-${var.custom_image_created_at}"
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }

    mode = "READ_WRITE"
  }

  # can_ip_forward      = false
  # deletion_protection = false
  # enable_display = false

  # labels = {
  #   goog-ec-src = "vm_add-tf"
  # }

  machine_type = var.vm_instance_machine_type
  name         = "${var.vm_instance_name}${count.index == 0 ? "" : count.index}"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    # subnetwork  = "projects/${var.project_id}/regions/us-west1/subnetworks/webapp${count.index == 0 ? "" : count.index}"
    subnetwork = google_compute_subnetwork.subnet_webapp[count.index].id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags                      = ["http-server"]
  zone                      = var.zone
  allow_stopping_for_update = true
}
