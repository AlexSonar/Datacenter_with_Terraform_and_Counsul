##########################################
# Creating AWS instance for Nomad-Server #
##########################################
resource "aws_instance" "nomad" {
  ami                     = var.ami
  count                   = var.nomad_cluster_size
  instance_type           = var.instance_type
  key_name                = var.key_name


  subnet_id               = var.subnet_id
  iam_instance_profile    = aws_iam_instance_profile.nomad.name
  user_data               = data.template_file.nomad_server_userdata.rendered
  vpc_security_group_ids  = [aws_security_group.nomad.id]

  tags = {
    Name                  = "nomad-server"
    role                  = "nomad-server"
  }
}


##########################################################
# Creating AWS Nomad-serversconfiguration via a template #
##########################################################
data "template_file" "nomad_server_userdata" {
  template = file("${path.module}/config/nomad-userdata.sh.tpl")
  vars = {
    BASE_PACKAGES_SNIPPET         = file("${path.module}/../shared_config/install_base_packages.sh")
    DNSMASQ_CONFIG_SNIPPET        = file("${path.module}/../shared_config/install_dnsmasq.sh")
    CONSUL_INSTALL_SNIPPET        = data.template_file.consul_install_snippet.rendered
    CONSUL_CLIENT_CONFIG_SNIPPET  = file("${path.module}/../shared_config/consul_client_config.sh")
    NOMAD_INSTALL_SNIPPET         = file("${path.module}/../shared_config/install_nomad.sh.tpl")
  }
}

data "template_file" "consul_install_snippet" {
  template = file("${path.module}/../shared_config/install_consul.sh.tpl")
  vars = {
    CONSUL_VERSION                = var.consul_version
  }
}

data "template_file" "nomad_install_snippet" {
  template = file("${path.module}/../shared_config/install_nomad.sh.tpl")
  vars = {
    NOMAD_COUNT                   = var.nomad_cluster_size
  }
}

##############################################################
# Creating AWS security group for our nomad-server instances #
##############################################################
resource "aws_security_group" "nomad" {
  name   = var.name
  vpc_id = var.vpc_id
  tags   = {
    Name = var.name
  }

  # Allow VPC Ingress
  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#############################################################################
# Creating AWS IAM Role & Instance Profile that lets us use cloud auto-join #
#############################################################################
resource "aws_iam_instance_profile" "nomad" {
    name = "nomad-server"
    role = aws_iam_role.nomad.name
}

resource "aws_iam_role_policy" "nomad-server" {
    name = "nomad-server"
    role = aws_iam_role.nomad.name
    policy = <<EOF
{
    "Statement": [
        {
            "Sid": "consulautojoinfornomad",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role" "nomad" {
    name = "nomadServer"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
