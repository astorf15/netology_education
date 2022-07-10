# Network
resource "yandex_vpc_network" "default" {
  name = "net_stage"
}

resource "yandex_vpc_subnet" "default" {
  name           = "subnet2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.3.2.0/24"]
}
