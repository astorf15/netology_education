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
