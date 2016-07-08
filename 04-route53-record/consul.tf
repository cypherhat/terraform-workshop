module "consul" {
  source = "github.com/sethvargo/tf-consul-atlas-join"

  ami     = "${lookup(var.aws_amis, var.aws_region)}"
  servers = 3

  datacenter = "dc1"

  subnet_id      = "${aws_subnet.environment_name.id}"
  security_group = "${aws_security_group.environment_name.id}"

  key_name         = "${aws_key_pair.environment_name.key_name}"
  private_key_path = "${path.module}/${var.private_key_path}"

  atlas_environment = "${var.atlas_environment}"
  atlas_token       = "${var.atlas_token}"
}
