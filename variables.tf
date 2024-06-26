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

variable "proxy_only_subnet_name_prefix" {
  type = string
}

variable "webapp_ip_cidr_range" {
  type = string
}

variable "db_ip_cidr_range" {
  type = string
}

variable "proxy_only_ip_cidr_range" {
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

variable "proxy_only_subnet_purpose" {
  type = string
}

variable "proxy_only_subnet_role" {
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

variable "allow_proxy_firewall_name_prefix" {
  type = string
}

variable "allow_proxy_allow_tcp_ports" {
  type = list(string)
}

variable "allow_health_check_firewall_name_prefix" {
  type = string
}

variable "allow_health_check_firewall_source_ranges" {
  type = list(string)
}

variable "firewall_target_tag" {
  type = string
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

variable "peering_routes_import_custom_routes" {
  type = bool
}

variable "peering_routes_export_custom_routes" {
  type = bool
}

variable "serverless_vpc_connector_name_prefix" {
  type = string
}

variable "serverless_vpc_connector_ip_cidr_range" {
  type = string
}

variable "serverless_vpc_connector_machine_type" {
  type = string
}

variable "serverless_vpc_connector_min_instances" {
  type = number
}

variable "serverless_vpc_connector_max_instances" {
  type = number
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

variable "vm_instance_tag" {
  type = string
}

variable "vm_instances_template_name_prefix" {
  type = string
}

variable "vm_instances_template_disk_is_for_boot" {
  type = bool
}

# VM instance group manager variables
variable "vm_instance_group_manager_name_prefix" {
  type = string
}

variable "vm_instance_group_manager_base_instance_name" {
  type = string
}

variable "vm_instance_group_manager_initial_delay_sec" {
  type = number
}

variable "vm_instance_group_manager_named_port_name" {
  type = string
}

variable "vm_instance_group_manager_named_port_port" {
  type = number
}

# VM autoscaler variables
variable "vm_autoscaler_name_prefix" {
  type = string
}

variable "vm_autoscaler_max_replicas" {
  type = number
}

variable "vm_autoscaler_min_replicas" {
  type = number
}

variable "vm_autoscaler_cooldown_period" {
  type = number
}

variable "vm_autoscaler_cpu_utilization_target" {
  type = number
}

# Load balancer variables
variable "lb_external_ip_address_name_prefix" {
  type = string
}

variable "lb_external_ip_address_type" {
  type = string
}

variable "lb_health_check_name_prefix" {
  type = string
}

variable "lb_health_check_timeout_sec" {
  type = number
}

variable "lb_health_check_check_interval_sec" {
  type = number
}

variable "lb_health_check_healthy_threshold" {
  type = number
}

variable "lb_health_check_unhealthy_threshold" {
  type = number
}

variable "lb_health_check_port" {
  type = number
}

variable "lb_health_check_port_specification" {
  type = string
}

variable "lb_health_check_request_path" {
  type = string
}

variable "lb_health_check_log_config_enabled" {
  type = bool
}

variable "lb_backend_service_name_prefix" {
  type = string
}

variable "lb_backend_service_scheme" {
  type = string
}

variable "lb_backend_service_protocol" {
  type = string
}

variable "lb_backend_service_session_affinity" {
  type = string
}

variable "lb_backend_service_timeout_sec" {
  type = number
}

variable "lb_backend_service_balancing_mode" {
  type = string
}

variable "lb_backend_service_capacity_scaler" {
  type = number
}

variable "lb_url_map_name_prefix" {
  type = string
}

variable "lb_proxy_name_prefix" {
  type = string
}

variable "lb_forwarding_rule_name_prefix" {
  type = string
}

variable "lb_forwarding_rule_ip_protocol" {
  type = string
}

variable "lb_forwarding_rule_load_balancing_scheme" {
  type = string
}

variable "lb_forwarding_rule_port_range" {
  type = string
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

# Pub/Sub variables
variable "pubsub_topic_name_prefix" {
  type = string
}

variable "pubsub_topic_message_retention_duration" {
  type = string
}

variable "pubsub_subscription_name_prefix" {
  type = string
}

variable "pubsub_subscription_ack_deadline_seconds" {
  type = number
}

variable "pubsub_subscription_message_retention_duration" {
  type = string
}

variable "pubsub_subscription_x_goog_version" {
  type = string
}

# Cloud Function variables
variable "mailchimp_api_key" {
  type = string
}

variable "storage_bucket_name_prefix" {
  type = string
}

variable "storage_bucket_object_name_prefix" {
  type = string
}

variable "storage_bucket_object_cache_control" {
  type = string
}

variable "cloud_function_name_prefix" {
  type = string
}

variable "cloud_function_runtime" {
  type = string
}

variable "cloud_function_entry_point" {
  type = string
}

variable "cloud_function_max_instance_count" {
  type = number
}

variable "cloud_function_min_instance_count" {
  type = number
}

variable "cloud_function_available_memory" {
  type = string
}

variable "cloud_function_timeout_seconds" {
  type = number
}

variable "cloud_function_ingress_settings" {
  type = string
}

variable "cloud_function_all_traffic_on_latest_revision" {
  type = bool
}

variable "cloud_function_trigger_event_type" {
  type = string
}

variable "cloud_function_retry_policy" {
  type = string
}

variable "cloud_function_sa_id_prefix" {
  type = string
}

variable "cloud_function_display_name" {
  type = string
}

# SSL variables
variable "ssl_certificate_name" {
  type = string
}

# CMEK variables
variable "kms_key_ring_name_suffix_length" {
  type = number
}

variable "compute_system_service_account_email" {
  type = string
}

variable "cmek_rotation_period" {
  type = string
}

variable "kms_key_ring_name_prefix" {
  type = string
}

variable "kms_crypto_key_vm_name_prefix" {
  type = string
}

variable "kms_crypto_key_bucket_name_prefix" {
  type = string
}

variable "kms_crypto_key_db_name_prefix" {
  type = string
}


# GCS variables
variable "archive_name" {
  type = string
}
