terraform {
  # cloud {
  #   organization = "brightblueray"  #Update to your TFC Org 

  #   workspaces {
  #     name = "Cyera-lab"
  #   }
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Provider Doc - https://registry.terraform.io/providers/hashicorp/aws/latest
provider "aws" {
  # Configuration options
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Sandbox"
      Owner = "ray.ryjewski"
      Team = "SE"
      Project = "Internal"
    }
  }

  # Set Environment Variables in your terminal for Auth
    # export AWS_ACCESS_KEY_ID="anaccesskey"
    # export AWS_SECRET_ACCESS_KEY="asecretkey"
    # export AWS_SESSION_TOKEN="aSessionToken"
}

# Module Doc - https://registry.terraform.io/modules/hashicorp/dir/template/latest
module "sample_files" {
  source  = "hashicorp/dir/template"
  version = "1.0.2"
  
  base_dir="samples"
}

##################
## S3 Bucket Setup
##################

# Create the S3 Bucket
resource "aws_s3_bucket" "private_bucket" {
    bucket = "rkr-priviate-bucket"
    # acl = "private"
}

# Anything in samples dir will be copied to the S3 bucket
resource "aws_s3_object" "sample_data_files" {
  for_each = module.sample_files.files

  bucket = aws_s3_bucket.private_bucket.bucket
  key = each.key
  source = each.value.source_path
}

output "Bucket_arn" {
  description = "Bucket arn"
  value       = aws_s3_bucket.private_bucket.arn
  sensitive   = false
}