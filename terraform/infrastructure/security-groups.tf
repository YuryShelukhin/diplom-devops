# Security group для bastion
resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-sg"
  network_id  = yandex_vpc_network.k8s_network.id

  # SSH доступ
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group для masters
resource "yandex_vpc_security_group" "masters_sg" {
  name        = "masters-sg"
  network_id  = yandex_vpc_network.k8s_network.id

  # SSH с bastion
  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion"
    port           = 22
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  # Kubernetes API
  ingress {
    protocol       = "TCP"
    description    = "K8s API"
    port           = 6443
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # etcd
  ingress {
    protocol       = "TCP"
    description    = "etcd"
    from_port      = 2379
    to_port        = 2380
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # Kubelet API
  ingress {
    protocol       = "TCP"
    description    = "Kubelet"
    port           = 10250
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # Calico BGP
  ingress {
    protocol       = "TCP"
    description    = "Calico BGP"
    port           = 179
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # NodePort для доступа через SSH tunnel
  ingress {
    protocol       = "TCP"
    description    = "NodePort"
    from_port      = 30000
    to_port        = 32767
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  # Весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group для workers
resource "yandex_vpc_security_group" "workers_sg" {
  name        = "workers-sg"
  network_id  = yandex_vpc_network.k8s_network.id

  # SSH с bastion
  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion"
    port           = 22
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  # Kubelet API
  ingress {
    protocol       = "TCP"
    description    = "Kubelet"
    port           = 10250
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # NodePort для доступа через SSH tunnel
  ingress {
    protocol       = "TCP"
    description    = "NodePort"
    from_port      = 30000
    to_port        = 32767
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  # Calico BGP
  ingress {
    protocol       = "TCP"
    description    = "Calico BGP"
    port           = 179
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # Весь исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}