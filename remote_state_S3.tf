#create an S3 bucket by using the aws_s3_bucket resource:
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "sushank-bucket"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }


  tags = {
    Name        = "sushank-terraform-bucket"
    Environment = "dev"
  }
}

# prevent_destroy is the second lifecycle setting

# # Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "enabled_version" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# # Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrypt" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_state_bucket_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}






# output "s3_bucket_arn" {
# value= aws_s3_bucket.terraform_state.arn
# description = "The ARN of the S3 bucket"
# }
# output "dynamodb_table_name" {
# value= aws_dynamodb_table.terraform_locks.name
# description = "The name of the DynamoDB table"
# }


# If you ever wanted to delete the S3 bucket and DynamoDB table, you’d
# have to do this two-step process in reverse:
# 1. Go to the Terraform code, remove the backend configuration, and
# rerun terraform init to copy the Terraform state back to your
# local disk.
# 2. Run terraform destroy to delete the S3 bucket and DynamoDB
# table.