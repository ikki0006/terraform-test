provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      "Environment" = var.env
      "CreateBy"    = "terraform"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"
  system = var.system
  env    = var.env
}

module "ecs" {
  source = "../../modules/ecs"
  system = var.system
  env    = var.env
}

module "sqs" {
  source = "../../modules/sqs"
  system = var.system
  env    = var.env
}
