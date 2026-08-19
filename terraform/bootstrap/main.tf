terraform {
  required_version = ">= 1.0.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.110"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

# Сервисный аккаунт для Terraform
resource "yandex_iam_service_account" "terraform_sa" {
  name        = "diplom-sa"
  description = "Service account for Terraform"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_roles" {
  for_each = toset([
    "storage.admin",
    "vpc.admin",
    "compute.admin",
    "iam.serviceAccounts.user"
  ])
  
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.terraform_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.terraform_sa.id
  description        = "Static access key for Terraform"
}

resource "yandex_storage_bucket" "terraform_state" {
  bucket = "netology-diplom-devops-terraform-state"
  access_key = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  
  versioning {
    enabled = true
  }
  
  #lifecycle {
  #  prevent_destroy = true
  #}
}