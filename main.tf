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

# ############
# ## RDS Setup
# ############
# # Available AZs
# data "aws_availability_zones" "available" {
#   state = "available"
# }

# # Create Database VPC - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name            = "database"
#   cidr            = "10.0.0.0/16"
#   azs             = data.aws_availability_zones.available.names
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway   = true
#   enable_vpn_gateway   = true
#   enable_dns_hostnames = true
#   enable_dns_support   = true
# }

# # Create Security Groups
# resource "aws_security_group" "rds" {
#   name   = "northwind_rds"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # egress {
#   #   from_port   = 0
#   #   to_port     = 0
#   #   protocol    = "tcp"
#   #   cidr_blocks = ["0.0.0.0/0"]
#   # }
# }

# # Create Subnet Group
# resource "aws_db_subnet_group" "database_sng" {
#   name       = "database"
#   subnet_ids = module.vpc.public_subnets
# }

# # Log Connections
# resource "aws_db_parameter_group" "northwind" {
#   name   = "northwind"
#   family = "postgres15"

#   parameter {
#     name  = "log_connections"
#     value = "1"
#   }
# }

# # # Create PostGreSQL DB
# resource "aws_db_instance" "northwind" {
#   # allocated_storage      = 10
#   snapshot_identifier = "arn:aws:rds:us-east-1:801091429065:snapshot:northwind-snapshot"  # User/Pwd : postgres/foobarbaz
#   # db_name                = "northwind"
#   db_subnet_group_name   = aws_db_subnet_group.database_sng.name
#   # engine                 = "postgres"
#   # engine_version         = "14.7"
#   instance_class         = "db.t3.micro"
#   # username               = "postgres"
#   # password               = var.db_password
#   parameter_group_name   = aws_db_parameter_group.northwind.name
#   publicly_accessible    = true
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [aws_security_group.rds.id]
# }


# ##
# ## Outputs
# ##
# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.northwind.address
#   sensitive   = false
# }

# output "rds_dbname" {
#   description = "RDS instance dbname"
#   value       = aws_db_instance.northwind.db_name
#   sensitive   = false
# }

# output "rds_port" {
#   description = "RDS instance port"
#   value       = aws_db_instance.northwind.port
#   sensitive   = false
# }

# output "rds_username" {
#   description = "RDS instance root username"
#   value       = aws_db_instance.northwind.username
#   sensitive   = false
# }

# output "rds_pwd" {
#   description = "RDS instance pwd"
#   value       = "foobarbaz"
#   sensitive   = false
# }