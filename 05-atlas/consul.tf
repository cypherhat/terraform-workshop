# This is the Consul Terraform module. This module is actually bundled within
# Consul at https:#github.com/hashicorp/consul in the Terraform folder.
module "consul" {
  # This is the source of the Consul module.
  source = "github.com/sethvargo/tf-consul-atlas-join"

  name = "${var.environment_name}"
  # This is the specific AMI id to use for the Consul servers.
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  datacenter = "dc1"
  # This tells the Consul module to create 3 servers.
  servers = 3

  # This tells the Consul module to launch inside our VPC.
  subnet_id      = "${aws_subnet.my_environment.id}"
  security_group = "${aws_security_group.my_environment.id}"

  # These two arguments use outputs from another module. The ssh_keys module
  # we have been using outputs the key name and key path. The Consul module
  # takes those values as arguments.
  key_name         = "${aws_key_pair.my_environment.key_name}"
  private_key_path = "${path.module}/${var.private_key_path}"

  atlas_environment = "${var.atlas_environment}"
  atlas_token       = "${var.atlas_token}"

}
