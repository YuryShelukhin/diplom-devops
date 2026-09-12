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
  value = {
    for i, instance in yandex_compute_instance.master :
    "master-${i + 1}" => instance.network_interface[0].ip_address
  }
}

output "worker_ips" {
  description = "Worker nodes internal IPs"
  value = {
    for i, instance in yandex_compute_instance.worker :
    "worker-${i + 1}" => instance.network_interface[0].ip_address
  }
}

output "k8s_api_lb_ip" {
  description = "Internal LB IP for the Kubernetes API"
  value       = var.k8s_vip
}

# Generate the Ansible inventory from the template.
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    bastion_public_ip = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
    master_ips = {
      for i, instance in yandex_compute_instance.master :
      "master-${i + 1}" => instance.network_interface[0].ip_address
    }
    worker_ips = {
      for i, instance in yandex_compute_instance.worker :
      "worker-${i + 1}" => instance.network_interface[0].ip_address
    }
    ssh_key_path = pathexpand(var.ssh_public_key_path)
    vm_user      = var.vm_user
  })
  filename        = "${path.module}/../../ansible/inventory/hosts.yml"
  file_permission = "0644"

  depends_on = [
    yandex_compute_instance.bastion,
    yandex_compute_instance.master,
    yandex_compute_instance.worker,
  ]
}
