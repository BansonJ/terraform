###################
#
###################
variable "my_region" {
  description = "AWS Region"
  type = string
  default = "us-east-2"
}

variable "my_ami_ubuntu2204" {
  description = "AWS My AMI - Ubuntu 22.04 LTS(x86_64)"
  type = string
  default = "ami-0cfde0ea8edd312d4"
}

variable "my_instance_type" {
    description = "My Ubuntu Instance Type"
    type = string
    default = "t3.micro"
}

variable "my_userdata_changed" {
    description = "User Data Replace on Change"
    type = bool
    default = true
}

variable "my_webserver_tags" {
    description = "My webserver Tags"
    type = map
    default = {
        Name = "mywebserver"
    }
}

variable "my_sg_tags" {
    description = "My Security Group Tags"
    type = map(string)
    default = {
        Name = "allow_80"
    }
}

variable "my_http" {
    description = "My HTTP Port"
    type = number 
    default = 80
}


