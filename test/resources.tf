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
  count = 3
  name  = "dov-bear-${count.index}"
  ports {
    internal = 3000
    # external = 8080
    external = 8080 + count.index
  }
}

output "container_name" {
  value = join(",", docker_container.dov-bear-container[*].name)
}

output "container_ports" {
  value = join(",", [for p in docker_container.dov-bear-container[*].ports[*].external : element(p, 0)])
}

