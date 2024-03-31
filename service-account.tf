resource "google_service_account" "monitor_service_account" {
  count = length(var.vpc_list)

  account_id   = "monitor${count.index}"
  display_name = "Monitor Service Account ${count.index}"
}

# The below 2 are for logging and monitoring
resource "google_project_iam_binding" "iam_role_la" {
  count   = length(var.vpc_list)
  project = var.project_id
  role    = "roles/logging.admin"

  members = [
    google_service_account.monitor_service_account[count.index].member,
  ]
}
resource "google_project_iam_binding" "iam_role_mmw" {
  count   = length(var.vpc_list)
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    google_service_account.monitor_service_account[count.index].member,
  ]
}

# The below 2 are for pub/sub
resource "google_project_iam_binding" "iam_role_psp" {
  count   = length(var.vpc_list)
  project = var.project_id
  role    = "roles/pubsub.publisher"

  members = [
    google_service_account.monitor_service_account[count.index].member,
  ]
}

resource "google_project_iam_binding" "iam_role_pss" {
  count   = length(var.vpc_list)
  project = var.project_id
  role    = "roles/pubsub.subscriber"

  members = [
    google_service_account.monitor_service_account[count.index].member,
  ]
}

# resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
#   count    = length(var.vpc_list)
#   project  = google_cloudfunctions2_function.cloud_function.project
#   location = google_cloudfunctions2_function.cloud_function.location
#   service  = google_cloudfunctions2_function.cloud_function.name
#   role     = "roles/run.invoker"
#   member   = "serviceAccount:${google_service_account.monitor_service_account[count.index].email}"
# }

# resource "google_project_iam_binding" "iam_role_ri" {
#   count   = length(var.vpc_list)
#   project = var.project_id
#   role    = "roles/run.invoker"

#   members = [
#     google_service_account.monitor_service_account[count.index].member,
#   ]
# }

# resource "google_cloud_run_v2_service" "cloud_run_srv" {
#   count    = length(var.vpc_list)
#   name     = "cloud-run-srv"
#   location = var.region

#   template {
#     containers {
#       image = "us-docker.pkg.dev/cloudrun/container/hello"
#     }
#     service_account = google_service_account.monitor_service_account[count.index].email
#   }
# }

# resource "google_service_account" "cloud_function_service_account" {
#   count = length(var.vpc_list)

#   account_id   = "cloud-function${count.index}"
#   display_name = "Cloud Function Account ${count.index}"
# }

# resource "google_project_iam_binding" "iam_role_pse" {
#   count   = length(var.vpc_list)
#   project = var.project_id
#   role    = "roles/pubsub.admin"

#   members = [
#     google_service_account.cloud_function_service_account[count.index].member,
#   ]
# }

# resource "google_project_iam_binding" "iam_role_ri" {
#   count   = length(var.vpc_list)
#   project = var.project_id
#   role    = "roles/run.invoker"

#   members = [
#     google_service_account.cloud_function_service_account[count.index].member,
#   ]
# }
