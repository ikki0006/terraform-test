# ------
# ECR
# ------
module "ecr_api_01" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  repository_name                 = "${var.system}-${var.env}-ecr-api-01"
  repository_image_tag_mutability = "IMMUTABLE"
  registry_scan_type              = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = []
    }
  ]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}

# ------
# ECS
# ------
module "ecs_api_01" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.2"

  cluster_name = "${var.system}-${var.env}-ecs-api-01"

  cluster_settings = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]
}

# ------
# ECS
# ------



