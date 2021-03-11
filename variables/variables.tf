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