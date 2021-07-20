
resource "yandex_iam_service_account" "k8s" {
  name = "k8snodesrole"
}

//!TODO добавиьт роль EDITOR для service-ого аккаунта

resource "yandex_kubernetes_cluster" "regional" {
  name = "reginal-ha-cluster"

  network_id = yandex_vpc_network.k8s.id

  node_service_account_id = yandex_iam_service_account.k8s.id
  service_account_id = yandex_iam_service_account.k8s.id

  release_channel = "STABLE"

  master {
    version = "1.19"
    public_ip = true

    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = yandex_vpc_subnet.subnet
        content {
          zone = location.value.zone
          subnet_id = location.value.id
        }
      }
    }
  }
}


resource "yandex_kubernetes_node_group" "node_group1" {
  cluster_id = yandex_kubernetes_cluster.regional.id

  instance_template {
    platform_id = "standard-v2"

    metadata = {
      ssh-keys = "${local.vm_user}:${local.public_ssh_key}"
    }

    network_interface {
      subnet_ids = yandex_vpc_subnet.subnet.*.id
      nat = false
    }

    resources {
      memory = 2
      cores = 2
    }

    boot_disk {
      size = 20
    }
  }


  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
      dynamic "location" {
        for_each = yandex_vpc_subnet.subnet
        content {
          zone = location.value.zone
        }
      }
  }
}

output "k8s_info" {
  value = yandex_kubernetes_cluster.regional
}