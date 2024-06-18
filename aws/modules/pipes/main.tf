# ------
# Event Bridge pipes
# ------
resource "aws_pipes_pipe" "pipe_sample_01" {
  name     = "${var.system}-${var.env}-pipe-01"
  role_arn = aws_iam_role.role_pipe_sample_01.arn
  source   = var.source_sqs
  target   = var.target_ecs

  target_parameters {
    ecs_task_parameters {
      enable_ecs_managed_tags = true
      task_count              = 1
      task_definition_arn     = var.task_def
      network_configuration {
        aws_vpc_configuration {
          subnets         = var.subnets
          security_groups = []
        }
      }
    }
  }
  log_configuration {
    level = "ERROR"
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.log_group_pipe_01.arn
    }
  }
}

# ------
# IAM
# ------
data "aws_caller_identity" "main" {}

resource "aws_iam_role" "role_pipe_sample_01" {
  name = "${var.system}-${var.env}-role-pipe-01"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.main.account_id
        }
      }
    }
  })
}

resource "aws_iam_role_policy" "role_policy_pipe_sample_01" {
  role = aws_iam_role.role_pipe_sample_01.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
        ],
        Resource = [
          var.source_sqs,
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask"
        ],
        Resource = [
          "${var.task_def}:*",
          var.task_def
        ],
        Condition = {
          ArnLike = {
            "ecs:cluster" : var.target_ecs
          },
        }
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole"
        Resource = "*"
        Condition = {
          StringLike = {
            "iam:PassedToService" : "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}

# ------
# log group
# ------
resource "aws_cloudwatch_log_group" "log_group_pipe_01" {
  name              = "/aws/vendedlogs/pipes/${var.system}-${var.env}-pipe-01"
  retention_in_days = 7
}
