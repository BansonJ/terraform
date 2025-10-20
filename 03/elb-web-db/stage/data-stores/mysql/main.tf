terraform {
  backend "s3" {
    bucket = "mybucket-1999-0313-1111"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "myDynamoDBTable"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "mydb_instance" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  username             = var.dbuser
  password             = var.dbpassword
}









