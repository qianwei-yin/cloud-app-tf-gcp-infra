terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.16.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "random" {
}
