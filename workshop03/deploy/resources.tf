# Resources / var/ data/module/local

data "digitalocean_ssh_key" "SSH_KEY" {
  name = "mbp"
}

data "digitalocean_image" "goldenCodeServer" {
  name = "workshop3-codeserver"
}


resource "digitalocean_droplet" "app" {
  name     = "workshop3-app"
  image    = data.digitalocean_image.goldenCodeServer.id
  region   = "sgp1"
  size     = "s-1vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.SSH_KEY.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.private_key)
  }
}

resource "local_file" "ansible_conf" {
  filename = "inventory.yaml"
  content = templatefile("inventory.yaml.tftpl", {
    resource_name        = "server-0"
    droplet_ip           = digitalocean_droplet.app.ipv4_address
    privatekey           = var.private_key
    code_server_password = var.code_server_password
    code_server_domain   = "code-server.${digitalocean_droplet.app.ipv4_address}.nip.io"
  })
  file_permission = "0644"

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yaml playbook.yaml"
  }
}

resource "local_file" "root_at_ip" {
  filename        = "root@${digitalocean_droplet.app.ipv4_address}"
  content         = ""
  file_permission = "0644"
}

output "codeserver_ip_address" {
  value = digitalocean_droplet.app.ipv4_address
}
