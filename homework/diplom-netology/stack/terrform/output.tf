# Proxy
output "internal_ip_proxy" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.proxy.network_interface.0.ip_address
}

output "external_ip_proxy" {
  description = "The external IP address of the instance"
  value       = yandex_compute_instance.proxy.network_interface.0.nat_ip_address
}

output "fqdn_proxy" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.proxy.fqdn
}

# db01
output "internal_ip_db01" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.db01.network_interface.0.ip_address
}
output "fqdn_db01" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.db01.fqdn
}

# db02
output "internal_ip_db02" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.db02.network_interface.0.ip_address
}
output "fqdn_db02" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.db02.fqdn
}

# app
output "internal_ip_app" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.app.network_interface.0.ip_address
}
output "fqdn_app" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.app.fqdn
}

# gitlab
output "internal_ip_gitlab" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.gitlab.network_interface.0.ip_address
}
output "fqdn_gitlab" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.gitlab.fqdn
}

# runner
output "internal_ip_runner" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.runner.network_interface.0.ip_address
}
output "fqdn_runner" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.runner.fqdn
}


# monitoring
output "internal_ip_monitoring" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.monitoring.network_interface.0.ip_address
}
output "fqdn_monitoring" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.monitoring.fqdn
}


