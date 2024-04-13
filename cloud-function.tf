/*
resource "google_storage_bucket" "cloud_function_bucket" {
  name     = "csye6225-qy-cloud-function-bucket"
  location = var.region
}

resource "google_storage_bucket_object" "cloud_function_archive" {
  name   = "cloud-function-zip"
  bucket = google_storage_bucket.cloud_function_bucket.name
  source = "../serverless/${var.archive_name}"

  cache_control = "no-cache"
}

# resource "google_storage_bucket" "trigger_bucket" {
#   name     = "csye6225-qy-trigger-bucket"
#   location = var.region
# }

data "google_storage_project_service_account" "gcs_account" {
}

# To use GCS CloudEvent triggers, the GCS service account requires the Pub/Sub Publisher(roles/pubsub.publisher) IAM role in the specified project.
# (See https://cloud.google.com/eventarc/docs/run/quickstart-storage#before-you-begin)
resource "google_project_iam_member" "gcs-pubsub-publishing" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_service_account" "test_service_account" {
  account_id   = "test-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

# Permissions on the service account used by the function and Eventarc trigger
resource "google_project_iam_member" "invoking" {
  project    = var.project_id
  role       = "roles/run.invoker"
  member     = "serviceAccount:${google_service_account.test_service_account.email}"
  depends_on = [google_project_iam_member.gcs-pubsub-publishing]
}

resource "google_project_iam_member" "event-receiving" {
  project    = var.project_id
  role       = "roles/eventarc.eventReceiver"
  member     = "serviceAccount:${google_service_account.test_service_account.email}"
  depends_on = [google_project_iam_member.invoking]
}

resource "google_project_iam_member" "artifactregistry-reader" {
  project    = var.project_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.test_service_account.email}"
  depends_on = [google_project_iam_member.event-receiving]
}
*/
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_kms_crypto_key_iam_binding" "kms_crypto_key_iam_binding" {
  count         = length(var.vpc_list)
  crypto_key_id = google_kms_crypto_key.kms_crypto_key_bucket[count.index].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_storage_bucket" "cloud_function_bucket" {
  count    = length(var.vpc_list)
  name     = "${var.storage_bucket_name_prefix}${count.index}"
  location = var.region

  encryption {
    default_kms_key_name = google_kms_crypto_key.kms_crypto_key_bucket[count.index].id
  }

  depends_on = [google_kms_crypto_key_iam_binding.kms_crypto_key_iam_binding]
}

resource "google_storage_bucket_object" "cloud_function_archive" {
  count  = length(var.vpc_list)
  name   = "${var.storage_bucket_object_name_prefix}${count.index}"
  bucket = google_storage_bucket.cloud_function_bucket[count.index].name
  source = "../serverless/${var.archive_name}"

  cache_control = var.storage_bucket_object_cache_control
}

resource "google_cloudfunctions2_function" "cloud_function" {
  count       = length(var.vpc_list)
  name        = "${var.cloud_function_name_prefix}${count.index}"
  location    = var.region
  description = "Function that will be triggered when new user is created"

  # depends_on = [
  #   google_project_iam_member.event-receiving,
  #   google_project_iam_member.artifactregistry-reader,
  # ]

  build_config {
    runtime     = var.cloud_function_runtime
    entry_point = var.cloud_function_entry_point # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.cloud_function_bucket[count.index].name
        object = google_storage_bucket_object.cloud_function_archive[count.index].name
      }
    }
  }

  service_config {
    max_instance_count = var.cloud_function_max_instance_count
    min_instance_count = var.cloud_function_min_instance_count
    available_memory   = var.cloud_function_available_memory
    timeout_seconds    = var.cloud_function_timeout_seconds
    ingress_settings   = var.cloud_function_ingress_settings
    vpc_connector      = google_vpc_access_connector.serverless_vpc_connector[count.index].name
    # vpc_connector_egress_settings  = "ALL_TRAFFIC"
    all_traffic_on_latest_revision = var.cloud_function_all_traffic_on_latest_revision
    service_account_email          = google_service_account.cloud_function_service_account[count.index].email

    environment_variables = {
      MAILCHIMP_API_KEY = "${var.mailchimp_api_key}"
      POSTGRES_PASSWORD = "${random_password.db_user_password[count.index].result}"
      POSTGRES_USERNAME = "${google_sql_user.db_user[count.index].name}"
      POSTGRES_DATABASE = "${google_sql_database.database[count.index].name}"
      POSTGRES_HOST     = "${google_sql_database_instance.postgres_instance[count.index].private_ip_address}"
    }
  }

  event_trigger {
    event_type            = var.cloud_function_trigger_event_type
    pubsub_topic          = google_pubsub_topic.verify_email_topic[count.index].id
    service_account_email = google_service_account.cloud_function_service_account[count.index].email
    trigger_region        = var.region
    retry_policy          = var.cloud_function_retry_policy
  }
}

resource "google_service_account" "cloud_function_service_account" {
  count        = length(var.vpc_list)
  account_id   = "${var.cloud_function_sa_id_prefix}${count.index}"
  display_name = var.cloud_function_display_name
}

resource "google_pubsub_topic_iam_binding" "topic_binding" {
  count   = length(var.vpc_list)
  project = google_pubsub_topic.verify_email_topic[count.index].project
  topic   = google_pubsub_topic.verify_email_topic[count.index].name
  role    = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account[count.index].email}",
  ]
}

resource "google_pubsub_subscription_iam_binding" "subscription_binding" {
  count        = length(var.vpc_list)
  subscription = google_pubsub_subscription.verify_email_subscription[count.index].name
  role         = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account[count.index].email}",
  ]
}

resource "google_cloud_run_service_iam_binding" "cloud_function_binding" {
  count    = length(var.vpc_list)
  project  = google_cloudfunctions2_function.cloud_function[count.index].project
  location = google_cloudfunctions2_function.cloud_function[count.index].location
  service  = google_cloudfunctions2_function.cloud_function[count.index].name
  role     = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account[count.index].email}",
  ]
}

resource "google_cloud_run_service_iam_binding" "cloud_function_binding2" {
  count    = length(var.vpc_list)
  project  = google_cloudfunctions2_function.cloud_function[count.index].project
  location = google_cloudfunctions2_function.cloud_function[count.index].location
  service  = google_cloudfunctions2_function.cloud_function[count.index].name
  role     = "roles/run.viewer"
  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account[count.index].email}",
  ]
}
