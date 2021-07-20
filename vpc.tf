

resource "yandex_vpc_network" "k8s" {
  name = "production"
  labels = local.default_labels
}




resource "yandex_vpc_subnet" "subnet" {
  network_id = yandex_vpc_network.k8s.id
  v4_cidr_blocks = [local.zones[count.index].address]

  count = length(local.zones)

  zone = local.zones[count.index].zone

  dhcp_options {
    domain_name = local.interanl_domain
  }
  labels = local.default_labels
}