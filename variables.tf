# Global variables
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

# VPC variables
variable "vpc_list" {
  type = list(string)
}

variable "vpc_auto_create_subnetworks" {
  type = bool
}

variable "vpc_routing_mode" {
  type = string
}

variable "vpc_delete_default_routes_on_create" {
  type = bool
}

variable "vpc_description" {
  type = string
}

variable "webapp_subnet_name_prefix" {
  type = string
}

variable "db_subnet_name_prefix" {
  type = string
}

variable "webapp_ip_cidr_range" {
  type = string
}

variable "db_ip_cidr_range" {
  type = string
}

variable "webapp_private_ip_google_access" {
  type = bool
}

variable "db_private_ip_google_access" {
  type = bool
}

variable "custom_route_name_prefix" {
  type = string
}

variable "custom_route_dest_range" {
  type = string
}

variable "custom_route_next_hop_gateway" {
  type = string
}

#  kwhkdenfkwdlke
variable "inbound_firewall_name_prefix" {
  type = string
}

variable "inbound_allow_tcp_ports" {
  type = list(string)
}

variable "inbound_firewall_source_ranges" {
  type = list(string)
}

variable "ssh_firewall_name_prefix" {
  type = string
}

variable "ssh_allow_tcp_ports" {
  type = list(string)
}

variable "ssh_firewall_source_ranges" {
  type = list(string)
}

# Private Services Access variables
variable "private_ip_address_name_prefix" {
  type = string
}

variable "private_ip_address_type" {
  type = string
}

variable "private_ip_address_purpose" {
  type = string
}

variable "private_ip_address_prefix_length" {
  type = number
}

variable "private_vpc_connection_service" {
  type = string
}

variable "private_vpc_connection_deletion_policy" {
  type = string
}

# Database variables
variable "random_db_name_suffix_byte_length" {
  type = number
}

variable "random_db_user_password_length" {
  type = number
}

variable "random_db_user_password_use_special" {
  type = bool
}

variable "db_instance_name_prefix" {
  type = string
}

variable "db_instance_version" {
  type = string
}

variable "db_instance_deletion_protection" {
  type = bool
}

variable "db_instance_availability_type" {
  type = string
}

variable "db_instance_tier" {
  type = string
}

variable "db_instance_disk_type" {
  type = string
}

variable "db_instance_disk_size" {
  type = number
}

variable "db_instance_ipv4_enabled" {
  type = bool
}

variable "db_instance_enable_private_path_for_google_cloud_services" {
  type = bool
}

variable "db_instance_enable_backup" {
  type = bool
}

variable "db_instance_enable_point_in_time_recovery" {
  type = bool
}

variable "db_name_prefix" {
  type = string
}

variable "db_user_name_prefix" {
  type = string
}

# VM instance variables
variable "custom_image_created_at" {
  type = string
}

variable "custom_image_name_prefix" {
  type = string
}

variable "vm_instance_name_prefix" {
  type = string
}

variable "vm_auto_delete_boot_disk" {
  type = bool
}

variable "boot_disk_size" {
  type = number
}

variable "boot_disk_type" {
  type = string
}

variable "boot_disk_mode" {
  type = string
}

variable "vm_instance_machine_type" {
  type = string
}

variable "vm_instance_networking_tier" {
  type = string
}

variable "vm_instance_queue_count" {
  type = number
}

variable "vm_instance_stack_type" {
  type = string
}

variable "vm_instance_automatic_restart" {
  type = bool
}

variable "vm_instance_on_host_maintenance" {
  type = string
}

variable "vm_instance_preemptible" {
  type = bool
}

variable "vm_instance_provisioning_model" {
  type = string
}

variable "service_account_email_local_part" {
  type = string
}

variable "service_account_scopes" {
  type = list(string)
}

variable "monitor_service_account_scopes" {
  type = list(string)
}

variable "vm_instance_enable_integrity_monitoring" {
  type = bool
}

variable "vm_instance_enable_secure_boot" {
  type = bool
}

variable "vm_instance_enable_vtpm" {
  type = bool
}

variable "vm_instance_tags" {
  type = list(string)
}

variable "vm_instance_allow_stopping_for_update" {
  type = bool
}

# DNS variables
variable "dns_record_name_prefix" {
  type = string
}

variable "dns_managed_zone_name" {
  type = string
}

variable "dns_record_type" {
  type = string
}

variable "dns_record_ttl" {
  type = number
}
