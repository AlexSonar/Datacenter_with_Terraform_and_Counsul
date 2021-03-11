####################
# Create variables #
####################
variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "bastion_public_subnet" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "azs" {}
variable "vpc_cidr" {}
variable "consul_version" {
    default = "1.9.1"
}
variable "consul_template_version" {
    default = "0.25.1"
}
variable "nomad_cluster_size" {
    default = 3
}
variable "consul_version" {
    default = "1.9.1"
}
variable "private_subnet_cidr" {
  type            = string
  description     = "The CIDR for our private subnet"
  default         = "10.0.1.0/24"
}
variable "public_subnet_cidr" {
  type            = string
  description     = "The CIDR for our public subnet"
  default         = "10.0.10.0/24"
}
variable "public_subnet_az" {
  type            = string
  default         = "us-west-2a"
}
variable "private_subnet_az" {
  type            = string
  default         = "us-west-2b"
}
variable "base_ec2_ami" {
  # us-west-2 ubuntu 20.04 HVM SSD
  default = "ami-07dd19a7900a1f049"
}
