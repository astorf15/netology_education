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