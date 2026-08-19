output "service_account_id" {
  description = "Service account ID"
  value       = yandex_iam_service_account.terraform_sa.id
}

output "bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = yandex_storage_bucket.terraform_state.bucket
}

output "access_key" {
  description = "Static access key for S3"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Static secret key for S3"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  sensitive   = true
}