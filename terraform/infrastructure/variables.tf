variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "../../secrets/ssh-key.pub"
}


variable "vm_user" {
  description = "VM user"
  type        = string
  default     = "ubuntu"
}

variable "zone_a" {
  description = "Zone A"
  type        = string
  default     = "ru-central1-a"
}

variable "zone_b" {
  description = "Zone B"
  type        = string
  default     = "ru-central1-b"
}

variable "zone_d" {
  description = "Zone D"
  type        = string
  default     = "ru-central1-d"
}