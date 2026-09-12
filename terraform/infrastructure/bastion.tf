resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = var.platform_id
  zone        = var.zone_a
  allow_stopping_for_update = true

  resources {
    cores         = var.bastion_resources.cores
    memory        = var.bastion_resources.memory
    core_fraction = var.bastion_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.bastion_resources.disk_size
      type     = var.bastion_resources.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet.id
    nat                = true
    ip_address         = "10.0.10.10"
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys  = "${var.vm_user}:${file(var.ssh_public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: ${var.vm_user}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.ssh_public_key_path)}
      package_update: true
      packages:
        - iptables
        - iptables-persistent
        - netfilter-persistent
      runcmd:
        - sysctl -w net.ipv4.ip_forward=1
        - echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
        - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        - netfilter-persistent save
        - netfilter-persistent reload
    EOF
  }
}
