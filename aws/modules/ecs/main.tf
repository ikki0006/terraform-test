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
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  create_task_exec_iam_role          = true
  task_exec_iam_role_name            = "${var.system}-${var.env}-ecs-api-01-task-exec-role-01"
  task_exec_iam_role_use_name_prefix = false
  task_exec_iam_role_description     = "Task execution role for ECS task"
  task_exec_iam_role_policies = {
    ecs_task   = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

}

# ------
# ECS task definition
# ------
resource "aws_ecs_task_definition" "ecs_task_definition_api_01" {
  family       = "${var.system}-${var.env}-ecs-api-01"
  track_latest = false
  container_definitions = jsonencode([
    {

      name      = "api"
      image     = "${module.ecr_api_01.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_api_01.task_exec_iam_role_arn
  memory                   = 512
  cpu                      = 256

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}
