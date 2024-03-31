resource "google_pubsub_topic" "verify_email_topic" {
  count                      = length(var.vpc_list)
  name                       = "${var.pubsub_topic_name_prefix}${count.index}"
  message_retention_duration = var.pubsub_topic_message_retention_duration
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  count = length(var.vpc_list)

  name  = "${var.pubsub_subscription_name_prefix}${count.index}"
  topic = google_pubsub_topic.verify_email_topic[count.index].id

  ack_deadline_seconds       = var.pubsub_subscription_ack_deadline_seconds
  message_retention_duration = var.pubsub_subscription_message_retention_duration

  push_config {
    push_endpoint = google_cloudfunctions2_function.cloud_function[count.index].service_config[0].uri

    attributes = {
      x-goog-version = var.pubsub_subscription_x_goog_version
    }
  }
}
