# Resources / var/ data/module/local

data "digitalocean_ssh_key" "SSH_KEY" {
  name = "mbp"
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

resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("nginx.conf.tftpl", {
    docker_host_ip  = var.docker_host_ip
    container_ports = [for p in docker_container.dov-bear-container[*].ports[*] : element(p, 0).external]
  })
  file_permission = "0644"
}

resource "local_file" "root_at_ip" {
  filename        = "root@${digitalocean_droplet.ubuntu.ipv4_address}"
  content         = ""
  file_permission = "0644"
}

resource "digitalocean_droplet" "ubuntu" {
  name     = "nginx"
  image    = "ubuntu-20-04-x64"
  region   = "sgp1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.SSH_KEY.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.private_key)
  }

  // Install nginx package
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install -y nginx"
    ]
  }

  // Copy config file over
  provisioner "file" {
    source      = "./nginx.conf"
    destination = "/etc/nginx/nginx.conf"
  }

  // Restart nginx cause we have updated the configuration
  provisioner "remote-exec" {
    inline = [
      "systemctl reload nginx"
    ]
  }
}


output "reverse_proxy_ip_address" {
  value = digitalocean_droplet.ubuntu.ipv4_address
}

output "container_endpoint" {
  value = join(",", [for p in docker_container.dov-bear-container[*].ports[*] : element(p, 0).external])
}
