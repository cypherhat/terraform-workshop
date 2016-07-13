resource "aws_instance" "server" {
  count = "${var.servers}"
  ami   = "${var.ami}"

  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${var.subnet_id}"

  vpc_security_group_ids = ["${var.security_group}"]

  connection {
    user     = "ubuntu"
    key_file = "${var.private_key_path}"
  }

  tags {
    Name = "${var.name}-consul-${count.index}"
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/scripts/wait-for-ready.sh",
      "${path.module}/scripts/install.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = <<EOH
# Write runtime data
sudo tee /etc/service/consul > /dev/null <<"EOF"
CONSUL_SERVERS="${var.servers}"
DC_NAME="${var.datacenter}"
NODE_NAME="${var.name}-consul-${count.index}"
EOF

# Restart the service
sudo service consul restart
EOH
  }
}

output "private_ip" {
  value = "${aws_instance.server.0.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.server.0.public_ip}"
}
