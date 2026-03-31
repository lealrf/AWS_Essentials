terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider using the Frankfurt region
provider "aws" {
  region = "eu-central-1"
  
  default_tags {
    tags = {
      Environment = "PoC"
      Project     = "HealthSync"
      ManagedBy   = "Terraform"
    }
  }
}