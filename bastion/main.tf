#####################################
# Creating AWS instance for Bastion #
#####################################
resource "aws_instance" "bastion" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.bastion_public_subnet
  vpc_security_group_ids  = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion"
    role = "bastion"
  }

  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("keys/${var.key_name}.pem")
      timeout     = "15m"
    }
    inline = [
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y sshguard"
    ]
  }
}

###########################################
# Creating AWS security group for Bastion #
###########################################
resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = var.vpc_id

  # SSH allowed from the Internet
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
