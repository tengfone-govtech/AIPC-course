# Resources / var/ data/module/local

data "digitalocean_ssh_key" "SSH_KEY" {
  name = "mbp-13"
}

resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tfpl", {
    containers = [for p in docker_container.dov-bear-container[*].ports[*] : element(p, 0).external]
  })
  file_permission = "0644"
  depends_on = [
    docker_container.dov-bear-container
  ]
}

resource "local_file" "root_at_ip" {
  filename        = "root@${digitalocean_droplet.ubuntu.ipv4_address}"
  content         = ""
  file_permission = "0644"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "ubuntu" {
  image    = "ubuntu-20-04-x64"
  name     = "web-1"
  region   = "sgp1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.SSH_KEY.fingerprint]

  connection {
    type        = "ssh"
    user        = "user"
    host        = self.ubuntu.ipv4_address
    private_key = file("/root/AIPC-course/workshop01/infra-course")

    provisioner "remote-exec" {
      inline = [
        "apt update",
        "apt install -y nginx"
      ]
    }

    provisioner "file" {
      source      = "./nginx.conf"
      destination = "/etc/nginx/nginx.conf"
    }

    provisioner "remote-exec" {
      inline = [
        "systemctl restart nginx"
      ]
    }
  }
}

resource "docker_image" "dov-bear" {
  name         = "chukmunnlee/dov-bear:v2"
  keep_locally = true
}

# Create a container
resource "docker_container" "dov-bear-container" {
  image = docker_image.dov-bear.latest
  count = var.num_container
  name  = "${var.INSTANCE_NAME}-${count.index + 1}"
  ports {
    internal = 3000
  }
  env = [
    "INSTANCE_NAME=dov-${count.index + 1}"
  ]
}

output "reverse_proxy_ip_address" {
  value = digitalocean_droplet.ubuntu.ipv4_address
}

output "container_endpoint" {
  value = join(",", [for p in docker_container.dov-bear-container[*].ports[*].external : element(p, 0)])
}
