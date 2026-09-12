# Master nodes
resource "yandex_compute_instance" "master" {
  count       = var.masters_count
  name        = "master-${count.index + 1}"
  hostname    = "master-${count.index + 1}"
  platform_id = var.platform_id
  zone        = [var.zone_a, var.zone_b, var.zone_d][count.index % 3]
  allow_stopping_for_update = true

  resources {
    cores         = var.master_resources.cores
    memory        = var.master_resources.memory
    core_fraction = var.master_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.master_resources.disk_size
      type     = var.master_resources.disk_type
    }
  }

  network_interface {
    subnet_id          = [yandex_vpc_subnet.subnet_a.id, yandex_vpc_subnet.subnet_b.id, yandex_vpc_subnet.subnet_d.id][count.index % 3]
    nat                = false
    ip_address         = "10.0.${count.index + 1}.${var.master_node_ip_suffix}"
    security_group_ids = [yandex_vpc_security_group.masters_sg.id]
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }

  depends_on = [yandex_compute_instance.bastion]
}
