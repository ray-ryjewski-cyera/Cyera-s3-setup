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
      version = "5.27.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

  # Creds stored in TFC Workspace as ENV Variables
    #  AWS_ACCESS_KEY_ID="anaccesskey"
    #  AWS_SECRET_ACCESS_KEY="asecretkey"
    # AWS_SESSION_TOKEN="aSessionToken"
}

module "sample_files" {
  source  = "hashicorp/dir/template"
  version = "1.0.2"
  
  base_dir="samples"
}


resource "aws_s3_bucket" "private_bucket" {
    bucket = "rkr-priviate-bucket"
    # acl = "private"
}

resource "aws_s3_object" "sample_data_files" {
  for_each = module.sample_files.files

  bucket = aws_s3_bucket.private_bucket.bucket
  key = each.key
  source = each.value.source_path
}


# resource "aws_s3_bucket" "public_read_bucket" {
#     bucket = "rkr-pub-r-bucket"
#     # acl = "public-read"
# }

# resource "aws_s3_bucket" "public_rw_bucket" {
#     bucket = "rkr-pub-rw-bucket"
#     # acl = "public-read-write"
# }

# resource "aws_s3_object" "a1mb-Test-docx" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "a1mb-Test-docx"
#   source = "samples/1-MB-Test.docx"
# }

# resource "aws_s3_object" "a1mb-Test-xlsx" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "a1mb-Test-xlsx"
#   source = "samples/1-MB-Test.xlsx"
# }

# resource "aws_s3_object" "a10mb-Test-docx" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "a10mb-Test-docx"
#   source = "samples/10-MB-Test.docx"
# }

# resource "aws_s3_object" "a10mb-Test-xlsx" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "a10mb-Test-xlsx"
#   source = "samples/10-MB-Test.xlsx"
# }

# resource "aws_s3_object" "sample-data-csv" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "sample-data-csv"
#   source = "samples/sample-data.csv"
# }

# resource "aws_s3_object" "sample-data-pdf" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "sample-data-pdf"
#   source = "samples/sample-data.pdf"
# }

# resource "aws_s3_object" "sample-data-xls" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "sample-data-xls"
#   source = "samples/sample-data.xls"
# }

# resource "aws_s3_object" "sample-data-xlsx" {
#   bucket = aws_s3_bucket.private_bucket.bucket
#   key    = "sample-data-xlsx"
#   source = "samples/sample-data.xlsx"
# }
