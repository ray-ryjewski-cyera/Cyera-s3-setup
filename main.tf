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
      Owner = "daniel.chan"
      Team = "CSE"
      Project = "Internal"
    }
  }
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

# random string resource
resource "random_string" "random_gen" {
  length = 8
  special  = false
  upper = false
}

# Create the S3 Bucket
resource "aws_s3_bucket" "private_bucket" {
    bucket = "djc-test-bucket-${random_string.random_gen.result}"
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
