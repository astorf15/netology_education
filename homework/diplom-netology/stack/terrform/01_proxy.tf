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

