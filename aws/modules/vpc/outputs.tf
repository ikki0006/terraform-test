
output "vpc_01_private_subnets" {
  value       = module.vpc_01.private_subnets
  description = "VPC subnets"
}
