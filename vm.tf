resource "google_compute_instance" "instance_from_custom_image" {
  count = length(var.vpc_list)

  boot_disk {
    auto_delete = var.vm_auto_delete_boot_disk
    device_name = "${var.vm_instance_name_prefix}${count.index}"

    initialize_params {
      image = "projects/${var.project_id}/global/images/${var.custom_image_name_prefix}${var.custom_image_created_at}"
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }

    mode = var.boot_disk_mode
  }

  machine_type = var.vm_instance_machine_type
  name         = "${var.vm_instance_name_prefix}${count.index}"

  network_interface {
    access_config {
      network_tier = var.vm_instance_networking_tier
    }

    queue_count = var.vm_instance_queue_count
    stack_type  = var.vm_instance_stack_type
    subnetwork  = google_compute_subnetwork.subnet_webapp[count.index].id
  }

  scheduling {
    automatic_restart   = var.vm_instance_automatic_restart
    on_host_maintenance = var.vm_instance_on_host_maintenance
    preemptible         = var.vm_instance_preemptible
    provisioning_model  = var.vm_instance_provisioning_model
  }

  # service_account {
  #   email  = "${var.service_account_email_local_part}@${var.project_id}.iam.gserviceaccount.com"
  #   scopes = var.service_account_scopes
  # }

  service_account {
    email  = google_service_account.monitor_service_account[count.index].email
    scopes = var.monitor_service_account_scopes
  }

  shielded_instance_config {
    enable_integrity_monitoring = var.vm_instance_enable_integrity_monitoring
    enable_secure_boot          = var.vm_instance_enable_secure_boot
    enable_vtpm                 = var.vm_instance_enable_vtpm
  }

  tags                      = var.vm_instance_tags
  zone                      = var.zone
  allow_stopping_for_update = var.vm_instance_allow_stopping_for_update

  metadata_startup_script = <<-EOF
      #!/bin/bash

      set -e

      sudo echo "POSTGRES_PASSWORD=${random_password.db_user_password[count.index].result}" >> /home/csye6225/myapp/.env
      sudo echo "POSTGRES_USERNAME=${google_sql_user.db_user[count.index].name}" >> /home/csye6225/myapp/.env
      sudo echo "POSTGRES_DATABASE=${google_sql_database.database[count.index].name}" >> /home/csye6225/myapp/.env
      sudo echo "POSTGRES_HOST=${google_sql_database_instance.postgres_instance[count.index].private_ip_address}" >> /home/csye6225/myapp/.env
      sudo echo "PUBSUB_INTERACTION=true" >> /home/csye6225/myapp/.env
      sudo echo "GCP_PROJECT_ID=${var.project_id}" >> /home/csye6225/myapp/.env
      sudo echo "PUBSUB_TOPIC_NAME=${google_pubsub_topic.verify_email_topic[count.index].name}" >> /home/csye6225/myapp/.env

      sudo chown -R "csye6225":"csye6225" "/home/csye6225/myapp/.env"
      sudo chmod -R 755 /home/csye6225/myapp/.env

      sudo systemctl start webapp
  EOF
}
