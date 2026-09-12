# Target group for master nodes
resource "yandex_lb_target_group" "k8s_masters" {
  name = "k8s-ha-masters"

  dynamic "target" {
    for_each = yandex_compute_instance.master
    content {
      address   = target.value.network_interface[0].ip_address
      subnet_id = target.value.network_interface[0].subnet_id
    }
  }
}

# Internal Network Load Balancer for the Kubernetes API
resource "yandex_lb_network_load_balancer" "k8s_api" {
  name = "k8s-ha-api"
  type = "internal"

  listener {
    name = "k8s-api"
    port = var.k8s_api_port
    internal_address_spec {
      subnet_id = yandex_vpc_subnet.subnet_a.id
      address   = var.k8s_vip
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s_masters.id

    healthcheck {
      name = "tcp${var.k8s_api_port}"
      tcp_options {
        port = var.k8s_api_port
      }
    }
  }

  depends_on = [yandex_compute_instance.master]
}
