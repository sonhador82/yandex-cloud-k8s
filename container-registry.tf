

resource "yandex_container_registry" "registry" {
  name = "main"
}

resource "yandex_container_repository" "nginx" {
  name = "${yandex_container_registry.registry.id}/nginx"
}
