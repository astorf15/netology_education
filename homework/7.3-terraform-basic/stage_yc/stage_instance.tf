# yc count instance
resource "yandex_compute_instance" "node" {
 count    = 2
 zone     = "ru-central1-a"
 name     = "node-${count.index + 1}-stage"
 hostname = "node-${count.index + 1}.netology.${terraform.workspace}"
 platform_id = "standard-v1"
 allow_stopping_for_update = true
 resources {
  cores  = 2
  memory = 2
 }
 
 boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-${terraform.workspace}-${count.index + 1}"
      type     = "network-nvme"
      size     = "30"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    nat        = true
    ip_address = "10.3.2.1${count.index + 1}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

// for each instance
locals {
  id = toset([
    "1",
   
  ])
}

resource "yandex_compute_instance" "each" {
  for_each    = local.id
  name        = "node-each-${each.key}-${terraform.workspace}"
  zone        = "ru-central1-a"
  platform_id = "standard-v2"
  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-${terraform.workspace}-each-${each.key}"
      type     = "network-nvme"
      size     = "30"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    nat        = true
    ip_address = "10.3.2.1${each.key+2}"
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
