terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.6.2"
    }
  }

  # backend "s3" {
  #   bucket         = "sushank-bucket"
  #   key            = "global/s3/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform_state_bucket_locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
}
