resource "random_id" "db_name_suffix" {
  count       = length(var.vpc_list)
  byte_length = var.random_db_name_suffix_byte_length
}

resource "random_password" "db_user_password" {
  count   = length(var.vpc_list)
  length  = var.random_db_user_password_length
  special = var.random_db_user_password_use_special
}

resource "google_sql_database_instance" "postgres_instance" {
  count               = length(var.vpc_list)
  name                = "${var.db_instance_name_prefix}-${random_id.db_name_suffix[count.index].hex}"
  region              = var.region
  database_version    = var.db_instance_version
  deletion_protection = var.db_instance_deletion_protection

  encryption_key_name = google_kms_crypto_key.kms_crypto_key_db[count.index].id

  # For private IP instance setup, note that the google_sql_database_instance does not actually interpolate values from google_service_networking_connection. You must explicitly add a depends_on reference.
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    availability_type = var.db_instance_availability_type
    tier              = var.db_instance_tier
    disk_type         = var.db_instance_disk_type
    disk_size         = var.db_instance_disk_size
    ip_configuration {
      ipv4_enabled                                  = var.db_instance_ipv4_enabled
      private_network                               = google_compute_network.vpc[count.index].id
      enable_private_path_for_google_cloud_services = var.db_instance_enable_private_path_for_google_cloud_services
    }
    backup_configuration {
      enabled                        = var.db_instance_enable_backup
      point_in_time_recovery_enabled = var.db_instance_enable_point_in_time_recovery
    }
  }
}

resource "google_sql_database" "database" {
  count    = length(var.vpc_list)
  name     = "${var.db_name_prefix}${count.index}"
  instance = google_sql_database_instance.postgres_instance[count.index].name
}

resource "google_sql_user" "db_user" {
  count    = length(var.vpc_list)
  name     = "${var.db_user_name_prefix}${count.index}"
  instance = google_sql_database_instance.postgres_instance[count.index].name
  password = random_password.db_user_password[count.index].result
}
