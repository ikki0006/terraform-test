output "ecs_cluster_api_01_arn" {
  value       = module.ecs_api_01.cluster_arn
  description = "ecs cluster api 01 arn"
}

output "ecs_task_definition_api_01_arn" {
  value       = aws_ecs_task_definition.ecs_task_definition_api_01.arn_without_revision
  description = "ecs_task_definition_api_01"
}
