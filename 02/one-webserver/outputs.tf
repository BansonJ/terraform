# Output Variable 정의

output "myweb_public_ip" {
    description = "My webserver public IP"
    value = aws_instance.example.public_ip
}

# tf state list
# tf state show aws_instance.example
# -> public_ip, public_dns 추출

output "myweb_public_dns" {
    description = "My webserver public dns"
    value = aws_instance.example.public_dns
}
