all:
  children:
    bastion_group:
      hosts:
        bastion-node:
          ansible_host: ${bastion_public_ip}
          ansible_user: ubuntu
    masters:
      hosts:
%{ for name, ip in master_ips ~}
        ${name}:
          ansible_host: ${ip}
          ansible_user: ubuntu
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/hw/diplom-devops/secrets/ssh-key -W %h:%p -q ubuntu@${bastion_public_ip}"'
%{ endfor ~}
    workers:
      hosts:
%{ for name, ip in worker_ips ~}
        ${name}:
          ansible_host: ${ip}
          ansible_user: ubuntu
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/hw/diplom-devops/secrets/ssh-key -W %h:%p -q ubuntu@${bastion_public_ip}"'
%{ endfor ~}
  vars:
    ansible_ssh_private_key_file: ~/hw/diplom-devops/secrets/ssh-key
    ansible_python_interpreter: /usr/bin/python3
    k8s_version: "1.30"
    pod_cidr: "10.244.0.0/16"
    service_cidr: "10.96.0.0/12"
    k8s_vip: "10.0.1.100"