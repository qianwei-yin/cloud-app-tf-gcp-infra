# resource "google_compute_managed_ssl_certificate" "lb_ssl_cert" {
#   count = length(var.vpc_list)
#   name  = "lb-ssl-cert${count.index}"

#   managed {
#     domains = [data.google_dns_managed_zone.env_dns_zone.dns_name]
#   }
# }

data "google_compute_ssl_certificate" "lb_ssl_cert" {
  name = var.ssl_certificate_name
}
