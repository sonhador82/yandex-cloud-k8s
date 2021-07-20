
resource "yandex_compute_instance" "sandbox1" {
  boot_disk {
    auto_delete = true
    initialize_params {
      size = 10
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  zone = tolist(yandex_vpc_subnet.subnet)[0].zone

  network_interface {
    subnet_id = tolist(yandex_vpc_subnet.subnet)[0].id
    nat = true
  }

  resources {
    cores = 2
    memory = 1
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "${local.vm_user}:${local.public_ssh_key}"
  }
}

