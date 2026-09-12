# Worker nodes
resource "yandex_compute_instance" "worker" {
  count       = var.workers_count
  name        = "worker-${count.index + 1}"
  hostname    = "worker-${count.index + 1}"
  platform_id = var.platform_id
  zone        = [var.zone_a, var.zone_b, var.zone_d][count.index % 3]

  resources {
    cores         = var.worker_resources.cores
    memory        = var.worker_resources.memory
    core_fraction = var.worker_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.worker_resources.disk_size
      type     = var.worker_resources.disk_type
    }
  }

  network_interface {
    subnet_id          = [yandex_vpc_subnet.subnet_a.id, yandex_vpc_subnet.subnet_b.id, yandex_vpc_subnet.subnet_d.id][count.index % 3]
    nat                = false
    ip_address         = "10.0.${count.index + 1}.${var.worker_node_ip_suffix}"
    security_group_ids = [yandex_vpc_security_group.workers_sg.id]
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }

  depends_on = [yandex_compute_instance.bastion]
}
