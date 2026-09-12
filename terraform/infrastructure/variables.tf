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

variable "image_id" {
  description = "Ubuntu 24.04 LTS image ID"
  type        = string
  default     = "fd83ica41cade1mj35sr"
}

variable "platform_id" {
  description = "Yandex Compute platform"
  type        = string
  default     = "standard-v3"
}

variable "masters_count" {
  description = "Number of Kubernetes control plane nodes"
  type        = number
  default     = 3
}

variable "workers_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
  default     = 3
}

variable "master_resources" {
  description = "Master node resources"
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 100
    disk_size     = 30
    disk_type     = "network-hdd"
  }
}

variable "worker_resources" {
  description = "Worker node resources (preemptible VMs)"
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 100
    disk_size     = 30
    disk_type     = "network-hdd"
  }
}

variable "bastion_resources" {
  description = "Bastion host resources"
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 50
    disk_size     = 20
    disk_type     = "network-hdd"
  }
}

variable "master_node_ip_suffix" {
  description = "Last octet for master node IPs in each subnet"
  type        = number
  default     = 20
}

variable "worker_node_ip_suffix" {
  description = "Last octet for worker node IPs in each subnet"
  type        = number
  default     = 30
}

variable "k8s_vip" {
  description = "Internal LB VIP for the Kubernetes API"
  type        = string
  default     = "10.0.1.100"
}

variable "k8s_api_port" {
  description = "Kubernetes API server port"
  type        = number
  default     = 6443
}

variable "k8s_api_dns" {
  description = "DNS name of the Kubernetes API endpoint used by kubeadm"
  type        = string
  default     = "k8s-api.internal"
}

variable "pod_cidr" {
  description = "Kubernetes pod network CIDR"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "Kubernetes service network CIDR"
  type        = string
  default     = "10.96.0.0/12"
}
