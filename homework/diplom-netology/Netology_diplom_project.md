# Дипломный практикум по курсу DevOps-инженер в YandexCloud

<details>tree<summary>Файловая структура проекта</summary> 

```bash
.
├── img
├── Netology_diplom_project.md
└── stack
    ├── ansible
    │   ├── deploy-stack.yml
    │   └── roles
    │       ├── configure-hosts-file
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── configure-ssh
    │       │   ├── handlers
    │       │   │   └── main.yml
    │       │   ├── tasks
    │       │   │   └── main.yml
    │       │   └── templates
    │       │       └── sshd_config.j2
    │       ├── install-app
    │       │   ├── files
    │       │   │   └── docker-compose-app.yml
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-docker
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-gitlab
    │       │   ├── defaults
    │       │   │   └── main.yml
    │       │   ├── files
    │       │   │   └── gitlab_add_repo.sh
    │       │   ├── handlers
    │       │   │   └── main.yml
    │       │   ├── tasks
    │       │   │   └── main.yml
    │       │   ├── templates
    │       │   │   └── gitlab.rb.j2
    │       │   └── vars
    │       │       └── Debian.yml
    │       ├── install-monitoring
    │       │   ├── files
    │       │   │   ├── alertmanager
    │       │   │   │   └── config.yml
    │       │   │   ├── docker-compose-monitoring.yml
    │       │   │   ├── grafana
    │       │   │   │   ├── dashboards
    │       │   │   │   │   └── Node_exporter_dashboard.json
    │       │   │   │   └── provisioning
    │       │   │   │       ├── dashboards
    │       │   │   │       │   └── dashboards.yml
    │       │   │   │       └── datasources
    │       │   │   │           └── prometheus.yml
    │       │   │   └── prometheus
    │       │   │       ├── alert.rules
    │       │   │       └── prometheus.yml
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-mysql-db01
    │       │   ├── files
    │       │   │   ├── docker-compose-mysql.yml
    │       │   │   ├── master.cnf
    │       │   │   └── master.sql
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-mysql-db02
    │       │   ├── files
    │       │   │   ├── docker-compose-mysql.yml
    │       │   │   ├── slave.cnf
    │       │   │   └── slave.sql
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-node-exporter
    │       │   ├── files
    │       │   │   └── docker-compose-exporter.yml
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-proxy
    │       │   ├── defaults
    │       │   │   └── main.yml
    │       │   ├── files
    │       │   │   ├── conf.d
    │       │   │   │   ├── alertmanager.rusdevops.ru.conf
    │       │   │   │   ├── custom-nginx
    │       │   │   │   ├── gitlab.rusdevops.ru.conf
    │       │   │   │   ├── grafana.rusdevops.ru.conf
    │       │   │   │   ├── prometheus.rusdevops.ru.conf
    │       │   │   │   └── rusdevops.ru.conf
    │       │   │   ├── snippets
    │       │   │   │   ├── proxy.conf
    │       │   │   │   └── ssl.conf
    │       │   │   └── ssl
    │       │   │       └── dhparams4096.pem
    │       │   ├── handlers
    │       │   │   └── main.yml
    │       │   └── tasks
    │       │       ├── certbot-install-snap.yml
    │       │       ├── main.yml
    │       │       └── renew-cron.yml
    │       ├── install-runner
    │       │   ├── files
    │       │   │   └── docker-compose-runner.yml
    │       │   └── tasks
    │       │       └── main.yml
    │       ├── install-tools
    │       │   └── tasks
    │       │       └── main.yml
    │       └── terraform.tfstate
    └── terrform
        ├── 01_proxy.tf
        ├── 02_db01.tf
        ├── 03_db02.tf
        ├── 04_app.tf
        ├── 05_gitlab.tf
        ├── 06_runner.tf
        ├── 07_monitoring.tf
        ├── inventory.tf
        ├── key.json
        ├── network.tf
        ├── output.tf
        ├── provider.tf
        ├── s3_bucket_yc.tf
        └── variables.tf

55 directories, 65 files
```
</details>

---
## Цели:

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.


---

## Этапы выполнения:

### 1. Зарегистрируем доменное имя `rusdevops.ru` и настроим ресурсные записи DNS
 ![dns_records](img)  

---
### 2. Подготовим инфраструктуру с помощью `Terraform` на базе облачного провайдера `YandexCloud`

* Создадим workspace `stage` 
```bash
terraform workspace new stage
```

#### Опишем конфигурацию провайдера `Yandex Cloud`

<details><summary>provider.tf</summary>

```bash
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.yandex_cloud_id
  folder_id                = var.yandex_folder_id
}
```
</details>


#### Создадим s3 бакет для хранения конфигруации `terraform.tfstate`

<details><summary>s3_bucket_yc.tf</summary>
 
 ```bash
 terraform {
   backend "s3" {
     endpoint             = "storage.yandexcloud.net"
     bucket               = "rusdevops-bucket"
     region               = "ru-central1"
     workspace_key_prefix = "environments"
     key                  = "terraform.tfstate"
     access_key           = "****"
     secret_key           = "****"
 
     skip_region_validation      = true
     skip_credentials_validation = true
   }
 }
```
</details>

#### Опишем конфигурацию сети и добавим таблицу маршрутизации для `NAT` инстанса

<details><summary>network.tf</summary>

```bash
# Network
resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_route_table" "nat-route-table" {
  description = "route table for subnet" 
  name        = "nat-route-table"
  network_id = yandex_vpc_network.net.id
  depends_on = [ yandex_compute_instance.proxy]
static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.proxy.network_interface.0.ip_address
    
  }
}

# Subnet
resource "yandex_vpc_subnet" "subnet-nat" {
  name           = "subnet-nat"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.2.1.0/24"]
}

# Subnet-nat
resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  route_table_id = yandex_vpc_route_table.nat-route-table.id
  v4_cidr_blocks = ["10.2.2.0/24"]
}
```
</details>

#### Опишем `output` для вывода информации об инстансах `(internal_ip, external_ip, fqdn)`

<details><summary>output.tf</summary>

```bash
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

```
</details>

#### Опишем конфигурацию инстанса с `reverse proxy` и `NAT`

<details><summary>01_proxy.tf</summary>

```bash
data "yandex_compute_image" "nat-image" {
  family = "nat-instance-ubuntu"
}
resource "yandex_compute_instance" "proxy" {
  name                      = "proxy"
  zone                      = "ru-central1-a"
  hostname                  = "proxy.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "${data.yandex_compute_image.nat-image.id}"
      name     = "root-proxy"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-nat.id
    nat        = true
    ip_address = "10.2.1.10"
    nat_ip_address = "62.84.127.27"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

#### Опишем конфигурацию инстансов для `MYSQL` кластера Master/Slave `(db01, db02)` 

<details><summary>02_db01.tf</summary>

```bash
resource "yandex_compute_instance" "db01" {
  name                      = "db01"
  zone                      = "ru-central1-a"
  hostname                  = "db01.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-db01"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.11"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

<details><summary>03_db02.tf</summary>

```bash
resource "yandex_compute_instance" "db02" {
  name                      = "db02"
  zone                      = "ru-central1-a"
  hostname                  = "db02.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-db02"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.12"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

#### Опишем конфигурацию инстанса для `Wordpress`

<details><summary>04_app.tf</summary>

```bash
resource "yandex_compute_instance" "app" {
  name                      = "app"
  zone                      = "ru-central1-a"
  hostname                  = "app.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-app"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.13"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
</details>

#### Опишем конфигурацию инстанса для `Gitlab`

<details><summary>05_gitlab.tf</summary>

```bash
resource "yandex_compute_instance" "gitlab" {
  name                      = "gitlab"
  zone                      = "ru-central1-a"
  hostname                  = "gitlab.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-gitlab"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.14"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

#### Опишем конфигурацию инстанса для `Gitlab Runner`

<details><summary>06_runner.tf</summary>

```bash
resource "yandex_compute_instance" "runner" {
  name                      = "runner"
  zone                      = "ru-central1-a"
  hostname                  = "runner.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-runner"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.15"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

#### Опишем конфигурацию инстанса для систем мониторинга `(Prometheus, Grafana, Alertmanager)`

<details><summary>07_monitoring.tf</summary>

```bash
resource "yandex_compute_instance" "monitoring" {
  name                      = "monitoring"
  zone                      = "ru-central1-a"
  hostname                  = "monitoring.rusdevops.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-monitoring"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = false
    ip_address = "10.2.2.16"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

```
</details>

#### Опишем конфигурацию для автоматического создания файла `inventory` для `Ansible`

<details><summary>inventory.tf</summary>

```bash
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

```
</details>

#### Опишем переменные для `Terraform`

<details><summary>variables.tf</summary>

```bash
# ID облака
variable "yandex_cloud_id" {
  default = "****"
}

# Folder облака
variable "yandex_folder_id" {
  default = "****"
}

# ID образа
variable "ubuntu_20" {
  default = "****"
}

# User
variable "linux_user" {
  default = "ubuntu"
}
```
</details>

---

### 3. Настроим внешний Reverse Proxy на основе Nginx и LetsEncrypt.