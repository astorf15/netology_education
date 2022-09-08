resource "local_file" "inventory" {
  content = <<-DOC
  # Ansible inventory by Terraform.
  
  [all:children]
  proxy
  app
  db
  gitlab
  monitoring
  
  [jump:children]
  app
  db
  gitlab
  monitoring
  
  [db:children]
  db01
  db02 
  
  [gitlab:children]
  gitlab_web
  runner
  
  [proxy]
  proxy.rusdevops.ru ansible_host=${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} 
  
  [db01]
  db01.rusdevops.ru ansible_host=${yandex_compute_instance.db01.network_interface.0.ip_address} 
  
  [db02]
  db02.rusdevops.ru ansible_host=${yandex_compute_instance.db02.network_interface.0.ip_address} 
  
  [app]
  app.rusdevops.ru ansible_host=${yandex_compute_instance.app.network_interface.0.ip_address} 
  
  [gitlab_web]
  gitlab.rusdevops.ru ansible_host=${yandex_compute_instance.gitlab.network_interface.0.ip_address} 
  
  [runner]
  runner.rusdevops.ru ansible_host=${yandex_compute_instance.runner.network_interface.0.ip_address} 

  [monitoring]
  monitoring.rusdevops.ru ansible_host=${yandex_compute_instance.monitoring.network_interface.0.ip_address} 

  [jump:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ${var.linux_user}@${yandex_compute_instance.proxy.network_interface.0.nat_ip_address}"'
  
  [all:vars]
  ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  ansible_user=${var.linux_user}
    DOC
  filename = "../../ansible/inventory"

  depends_on = [
    yandex_compute_instance.proxy,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.runner,
    yandex_compute_instance.monitoring,
  ]
}