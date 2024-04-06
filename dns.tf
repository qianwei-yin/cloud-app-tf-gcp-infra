data "google_dns_managed_zone" "env_dns_zone" {
  name = var.dns_managed_zone_name
}

resource "google_dns_record_set" "webapp" {
  count = length(var.vpc_list)

  name = data.google_dns_managed_zone.env_dns_zone.dns_name
  # name = "${var.dns_record_name_prefix}${count.index}.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  type = var.dns_record_type
  ttl  = var.dns_record_ttl

  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  # set to vm's ip address
  # rrdatas = [google_compute_instance.instance_from_custom_image[count.index].network_interface[0].access_config[0].nat_ip]

  # set to load balancer's ip address
  rrdatas = [google_compute_global_address.lb_external_ip_address[count.index].address]
}
