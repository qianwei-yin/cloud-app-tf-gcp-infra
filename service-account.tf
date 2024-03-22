resource "google_service_account" "monitor_service_account" {
  count = length(var.vpc_list)

  account_id   = "monitor${count.index}"
  display_name = "Monitor Service Account ${count.index}"
}

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
