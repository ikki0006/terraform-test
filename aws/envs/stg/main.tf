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

module "pipes" {
  source     = "../../modules/pipes"
  system     = var.system
  env        = var.env
  source_sqs = module.sqs.sqs_queue_sample_01_arn
  target_ecs = module.ecs.ecs_cluster_api_01_arn
  task_def   = module.ecs.ecs_task_definition_api_01_arn
  subnets    = module.vpc.vpc_01_private_subnets
}

