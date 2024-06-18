variable "env" {
  type        = string
  description = "enviroment name"
}

variable "system" {
  type        = string
  description = "system name"
}

variable "source_sqs" {
  type        = string
  description = "The ARN of the SQS queue"
}

variable "target_ecs" {
  type        = string
  description = "The ARN of the target ECS service"
}

variable "task_def" {
  type        = string
  description = "The ARN of the ECS task definition"
}

variable "subnets" {
  type        = list(string)
  description = "The private subnets"
}
