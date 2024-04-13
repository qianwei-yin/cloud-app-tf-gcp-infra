resource "random_id" "keyring_name_suffix" {
  count       = length(var.vpc_list)
  byte_length = var.kms_key_ring_name_suffix_length
}
resource "google_kms_key_ring" "keyring" {
  count    = length(var.vpc_list)
  name     = "${var.kms_key_ring_name_prefix}${random_id.keyring_name_suffix[count.index].hex}"
  location = var.region
}

resource "google_kms_crypto_key" "kms_crypto_key_vm" {
  count           = length(var.vpc_list)
  name            = "${var.kms_crypto_key_vm_name_prefix}${count.index}"
  key_ring        = google_kms_key_ring.keyring[count.index].id
  rotation_period = var.cmek_rotation_period
}

resource "google_kms_crypto_key" "kms_crypto_key_bucket" {
  count           = length(var.vpc_list)
  name            = "${var.kms_crypto_key_bucket_name_prefix}${count.index}"
  key_ring        = google_kms_key_ring.keyring[count.index].id
  rotation_period = var.cmek_rotation_period
}

resource "google_kms_crypto_key" "kms_crypto_key_db" {
  count           = length(var.vpc_list)
  name            = "${var.kms_crypto_key_db_name_prefix}${count.index}"
  key_ring        = google_kms_key_ring.keyring[count.index].id
  rotation_period = var.cmek_rotation_period
}
resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}
resource "google_kms_crypto_key_iam_binding" "crypto_key_db_iam" {
  count         = length(var.vpc_list)
  crypto_key_id = google_kms_crypto_key.kms_crypto_key_db[count.index].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}

resource "google_project_iam_binding" "vm_sa_kms_iam" {
  count   = length(var.vpc_list)
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${var.compute_system_service_account_email}"
  ]
}
