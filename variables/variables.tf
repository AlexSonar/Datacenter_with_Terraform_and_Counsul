variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "bastion_public_subnet" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "consul_version" {
    default = "1.9.1"
}
variable "consul_template_version" {
    default = "0.25.1"
}