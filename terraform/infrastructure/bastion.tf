resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = var.zone_a

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd83ica41cade1mj35sr" # Ubuntu 24.04 LTS
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    nat                = true
    ip_address         = "10.0.1.10"
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.ssh_public_key_path)}"
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