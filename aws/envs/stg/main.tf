terraform {
  required_version = ">=1.8.5"
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.54.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      "Environment" = var.env
      "CreateBy"    = "terraform"
    }
  }
}
