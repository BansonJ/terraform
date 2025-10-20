##############################
# 작업 순서
# 1. vpc 생성
# 2. IGW 생성 및 vpc 연결
# 3. public subnet 생성
# 4. routing table 생성 및 public subnet 연결
##############################

#provider 지정
provider "aws" {
  region = "us-east-2"
}

# vpc 생성
resource "aws_vpc" "myVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "myVPC"
  }
}

#IGW 생성 및 vpc 연결
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW"
  }
}

#public subnet 생성
resource "aws_subnet" "myPublicSubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "myPublicSubnet"
  }
}

# RT 생성 및 PubSN 연결
resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"  //목적지 ip
    gateway_id = aws_internet_gateway.myIGW.id
  }

  tags = {
    Name = "myRT"
  }
}

resource "aws_route_table_association" "myPublicRTAssoc" {
  subnet_id      = aws_subnet.myPublicSubnet.id
  route_table_id = aws_route_table.myRT.id
}

# security group 생성
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ec2 생성
resource "aws_instance" "myEC2" {
  ami           = "ami-077b630ef539aa0b5"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.myPublicSubnet.id
  user_data = <<EOF
#!/bin/bash
dnf -y install httpd mod_ssl
echo "MyWEB" > /var/www/html/index.html
systemctl enable --now httpd 
EOF

    user_data_replace_on_change = true

    vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "myEC2"
  }
}
