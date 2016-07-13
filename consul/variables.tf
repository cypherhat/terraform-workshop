variable "name" {
  description = "The name of the instances to create."
  default     = "consul"
}

variable "datacenter" {
  description = "The name of the data center"
}

variable "ami" {
  description = "The AMI ID to create the instances with."
}

variable "instance_type" {
  description = "The instance type."
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the keypair to use on the machine."
}

variable "private_key_path" {
  description = "The path to the private key on disk for provisioning."
  default     = "~/.ssh/id_rsa"
}

variable "subnet_id" {
  description = "The subnet ID to launch this instance in."
}

variable "security_group" {
  description = "The security group ID to launch this instance in."
}

variable "servers" {
  description = "The number of servers in the Consul cluster"
  default     = "3"
}
