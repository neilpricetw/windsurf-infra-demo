

# Optionally, you can define the provider here if you want to manage the backend resources with Terraform
provider "aws" {
  region = "ap-southeast-2"
}

# Example resources to create the S3 bucket and DynamoDB table for state management (uncomment and adjust as needed)
resource "aws_s3_bucket" "tf_state" {
  bucket        = "np-tfstate5"
  force_destroy = false

  tags = {
    Name        = "np-tfstate5"
    Environment = "terraform-backend"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# resource "aws_dynamodb_table" "tf_lock" {
#   name         = "<your-dynamodb-table>"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
