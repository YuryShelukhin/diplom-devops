output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "bastion_internal_ip" {
  description = "Bastion internal IP"
  value       = yandex_compute_instance.bastion.network_interface[0].ip_address
}

output "master_ips" {
  description = "Master nodes internal IPs"
  value       = {
    for i, instance in yandex_compute_instance.master : 
    "master-${i + 1}" => instance.network_interface[0].ip_address
  }
}

output "worker_ips" {
  description = "Worker nodes internal IPs"
  value       = {
    for i, instance in yandex_compute_instance.worker : 
    "worker-${i + 1}" => instance.network_interface[0].ip_address
  }
}