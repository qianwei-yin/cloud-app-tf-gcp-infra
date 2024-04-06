# Reserve an external IP address for the load balancer.
resource "google_compute_global_address" "lb_external_ip_address" {
  count = length(var.vpc_list)

  name         = "${var.lb_external_ip_address_name_prefix}${count.index}"
  address_type = var.lb_external_ip_address_type
  # network_tier = "STANDARD"
  # region       = var.region
}

resource "google_compute_health_check" "http_health_check" {
  count = length(var.vpc_list)

  name        = "${var.lb_health_check_name_prefix}${count.index}"
  description = "Health check via http"
  # region      = var.region

  timeout_sec         = var.lb_health_check_timeout_sec
  check_interval_sec  = var.lb_health_check_check_interval_sec
  healthy_threshold   = var.lb_health_check_healthy_threshold
  unhealthy_threshold = var.lb_health_check_unhealthy_threshold

  http_health_check {
    port               = var.lb_health_check_port
    port_specification = var.lb_health_check_port_specification
    request_path       = var.lb_health_check_request_path
    # port_name          = "health-check-port"
    # host = "1.2.3.4"
  }

  log_config {
    enable = var.lb_health_check_log_config_enabled
  }
}

resource "google_compute_backend_service" "lb_backend_service" {
  count = length(var.vpc_list)
  name  = "${var.lb_backend_service_name_prefix}${count.index}"
  # region                = var.region
  load_balancing_scheme = var.lb_backend_service_scheme
  health_checks         = [google_compute_health_check.http_health_check[count.index].id]
  protocol              = var.lb_backend_service_protocol
  # port_name             = "http"
  session_affinity = var.lb_backend_service_session_affinity
  timeout_sec      = var.lb_backend_service_timeout_sec
  backend {
    group           = google_compute_region_instance_group_manager.instance_group_manager[count.index].instance_group
    balancing_mode  = var.lb_backend_service_balancing_mode
    capacity_scaler = var.lb_backend_service_capacity_scaler
  }
}

resource "google_compute_url_map" "lb_url_map" {
  count = length(var.vpc_list)
  name  = "${var.lb_url_map_name_prefix}${count.index}"
  # region          = var.region
  default_service = google_compute_backend_service.lb_backend_service[count.index].id
}

resource "google_compute_target_https_proxy" "lb_proxy" {
  count = length(var.vpc_list)
  name  = "${var.lb_proxy_name_prefix}${count.index}"
  # region  = var.region
  url_map = google_compute_url_map.lb_url_map[count.index].id
  ssl_certificates = [
    data.google_compute_ssl_certificate.lb_ssl_cert.name
  ]
  depends_on = [
    data.google_compute_ssl_certificate.lb_ssl_cert
  ]
}

resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  count      = length(var.vpc_list)
  name       = "${var.lb_forwarding_rule_name_prefix}${count.index}"
  depends_on = [google_compute_subnetwork.subnet_proxy_only]
  # region     = var.region

  ip_protocol           = var.lb_forwarding_rule_ip_protocol
  load_balancing_scheme = var.lb_forwarding_rule_load_balancing_scheme
  port_range            = var.lb_forwarding_rule_port_range
  target                = google_compute_target_https_proxy.lb_proxy[count.index].id
  # network               = google_compute_network.vpc[count.index].id
  ip_address = google_compute_global_address.lb_external_ip_address[count.index].id
  # network_tier          = "STANDARD"
}
