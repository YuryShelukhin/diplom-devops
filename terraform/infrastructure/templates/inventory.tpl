all:
  children:
    bastion_group:
      hosts:
        bastion-node:
          ansible_host: ${bastion_public_ip}
          ansible_user: ${vm_user}
    masters:
      hosts:
%{ for name, ip in master_ips ~}
        ${name}:
          ansible_host: ${ip}
          ansible_user: ${vm_user}
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ${ssh_key_path} -W %h:%p -q ${vm_user}@${bastion_public_ip}"'
%{ endfor ~}
    workers:
      hosts:
%{ for name, ip in worker_ips ~}
        ${name}:
          ansible_host: ${ip}
          ansible_user: ${vm_user}
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ${ssh_key_path} -W %h:%p -q ${vm_user}@${bastion_public_ip}"'
%{ endfor ~}
  vars:
    ansible_ssh_private_key_file: ~/hw/diplom-devops/secrets/ssh-key
    ansible_python_interpreter: /usr/bin/python3
