# Master nodes
resource "yandex_compute_instance" "master" {
  count       = 3
  name        = "master-${count.index + 1}"
  hostname    = "master-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = count.index == 0 ? var.zone_a : count.index == 1 ? var.zone_b : var.zone_d
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd83ica41cade1mj35sr"  # Ubuntu 24.04 LTS
      size     = 50
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = count.index == 0 ? yandex_vpc_subnet.subnet_a.id : count.index == 1 ? yandex_vpc_subnet.subnet_b.id : yandex_vpc_subnet.subnet_d.id
    nat                = false
    ip_address         = "10.0.${count.index + 1}.20"
    security_group_ids = [yandex_vpc_security_group.masters_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }

  depends_on = [yandex_compute_instance.bastion]
}
