# yc compute instance
resource "yandex_compute_instance" "node" {
  count    = 1
  zone     = "ru-central1-a"
  name     = "node-${count.index + 1}-${terraform.workspace}"
  hostname = "node-${count.index + 1}.netology.${terraform.workspace}"
  platform_id = "standard-v1"
  // instance_type = s2.medium
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "root-prod-${count.index + 1}"
      type     = "network-nvme"
      size     = "30"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    nat        = true
    ip_address = "10.2.2.1${count.index + 1}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

