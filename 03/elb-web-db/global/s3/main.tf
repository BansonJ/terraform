provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket-1999-0313-1111"

  tags = {
    Name        = "mybucket"
  }
}

resource "aws_dynamodb_table" "myDynamoDBTable" {
  name             = "myDynamoDBTable"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}





