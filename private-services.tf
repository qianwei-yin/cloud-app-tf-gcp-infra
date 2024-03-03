# Private services access is a private connection between your VPC network and a network owned by Google or a third party. Google or the third party, entities who are offering services, are also known as service producers. The private connection enables VM instances in your VPC network and the services that you access to communicate exclusively by using internal IP addresses. VM instances don't need internet access or external IP addresses to reach services that are available through private services access.
# At a high level, to use private services access, you must allocate an IP address range (CIDR block) in your VPC network and then create a private connection to a service producer.
resource "google_compute_global_address" "private_ip_address" {
  count         = length(var.vpc_list)
  name          = "${var.private_ip_address_name_prefix}${count.index}"
  address_type  = var.private_ip_address_type
  purpose       = var.private_ip_address_purpose
  network       = google_compute_network.vpc[count.index].id
  prefix_length = var.private_ip_address_prefix_length
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = length(var.vpc_list)
  network                 = google_compute_network.vpc[count.index].name
  service                 = var.private_vpc_connection_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[count.index].name]
  deletion_policy         = var.private_vpc_connection_deletion_policy
}
