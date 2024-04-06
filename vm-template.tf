data "google_compute_image" "custom_machine_image" {
  name = "${var.custom_image_name_prefix}${var.custom_image_created_at}"
}

resource "google_compute_instance_template" "vm_instances_template" {
  count = length(var.vpc_list)

  name_prefix  = var.vm_instances_template_name_prefix
  description  = "This template is used to create multiple instances."
  machine_type = var.vm_instance_machine_type
  region       = var.region
  tags         = [var.vm_instance_tag, var.firewall_target_tag]

  # can_ip_forward = false

  // Create a new boot disk from an image
  disk {
    auto_delete  = var.vm_auto_delete_boot_disk
    boot         = var.vm_instances_template_disk_is_for_boot
    device_name  = "${var.vm_instance_name_prefix}${count.index}"
    source_image = data.google_compute_image.custom_machine_image.self_link
    mode         = var.boot_disk_mode
    disk_size_gb = var.boot_disk_size
    disk_type    = var.boot_disk_type
  }

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

  service_account {
    email  = google_service_account.monitor_service_account[count.index].email
    scopes = var.monitor_service_account_scopes
  }

  # shielded_instance_config {
  #   enable_integrity_monitoring = var.vm_instance_enable_integrity_monitoring
  #   enable_secure_boot          = var.vm_instance_enable_secure_boot
  #   enable_vtpm                 = var.vm_instance_enable_vtpm
  # }

  lifecycle {
    create_before_destroy = true
  }

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

resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  count = length(var.vpc_list)

  name   = "${var.vm_instance_group_manager_name_prefix}${count.index}"
  region = var.region
  # distribution_policy_target_shape = "BALANCED"

  version {
    instance_template = google_compute_instance_template.vm_instances_template[count.index].id
    name              = "primary"
  }

  # target_pools       = [google_compute_target_pool.foobar.id]
  base_instance_name = var.vm_instance_group_manager_base_instance_name

  auto_healing_policies {
    health_check      = google_compute_health_check.http_health_check[count.index].id
    initial_delay_sec = var.vm_instance_group_manager_initial_delay_sec
  }

  named_port {
    name = var.vm_instance_group_manager_named_port_name
    port = var.vm_instance_group_manager_named_port_port
  }

  # update_policy {
  #   minimal_action               = "REPLACE"
  #   type                         = "PROACTIVE"
  #   instance_redistribution_type = "NONE"
  # }
}

resource "google_compute_region_autoscaler" "autoscaler" {
  count = length(var.vpc_list)

  name   = "${var.vm_autoscaler_name_prefix}${count.index}"
  region = var.region
  target = google_compute_region_instance_group_manager.instance_group_manager[count.index].id

  autoscaling_policy {
    max_replicas    = var.vm_autoscaler_max_replicas
    min_replicas    = var.vm_autoscaler_min_replicas
    cooldown_period = var.vm_autoscaler_cooldown_period

    cpu_utilization {
      target = var.vm_autoscaler_cpu_utilization_target
    }
  }
}
