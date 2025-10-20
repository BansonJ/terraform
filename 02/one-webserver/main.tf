provider "aws" {
    region = var.my_region
}

resource "aws_instance" "example" {
    ami = var.my_ami_ubuntu2204
    instance_type = var.my_instance_type
    user_data = <<EOF
#!/bin/bash
sudo apt -y install apache2
echo "WEB" | sudo tee /var/www/html/index.html
sudo systemctl enable --now apache2
EOF

    user_data_replace_on_change = var.my_userdata_changed

    vpc_security_group_ids = [aws_security_group.allow_8080.id]

    tags = var.my_webserver_tags
}

resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "Allow 8080 inbound traffic and all outbound traffic"

  tags = var.my_sg_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_ipv4" {
  security_group_id = aws_security_group.allow_8080.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.my_http
  ip_protocol       = "tcp"
  to_port           = var.my_http
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_8080.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#input variable
#variable "my_region" {
#  default = "us-east-2"
#  description = "AWS Region"
#  type = string
#}

#variable "my_ami_ubuntu2204" {
#  default = "ami-0cfde0ea8edd312d4"
#  description = "AWS AMI - Ubuntu 24.04 LTS"
#  type = string
#}

#output variable
#output "myweb_public_ip" {
#  description = "my webserver public ip"
#  value = aws_instance.example.public_ip
#}





