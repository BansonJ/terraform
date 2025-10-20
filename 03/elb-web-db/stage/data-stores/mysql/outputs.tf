output "db_address" {
    value = aws_db_instance.mydb_instance.address
}

output "db_port" {
    value = aws_db_instance.mydb_instance.port
}
