# Resources / var/ data/module/local

data "digitalocean_ssh_key" "SSH_KEY" {
  name = "mbp"
}

resource "local_file" "ansible_conf" {
  filename = "inventory.yaml"
  content = templatefile("inventory.yaml.tftpl", {
    resource_name = "server-0"
    droplet_ip    = digitalocean_droplet.ansible.ipv4_address
    privatekey    = var.private_key
  })
  file_permission = "0644"
}

resource "local_file" "root_at_ip" {
  filename        = "root@${digitalocean_droplet.ansible.ipv4_address}"
  content         = ""
  file_permission = "0644"
}

resource "digitalocean_droplet" "ansible" {
  name     = "ansible"
  image    = "ubuntu-20-04-x64"
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

output "provisioned_ip_address" {
  value = digitalocean_droplet.ansible.ipv4_address
}

# ansible all -i inventory.yaml -m ping