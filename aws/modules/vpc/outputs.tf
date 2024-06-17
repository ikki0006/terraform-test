
output "vpc_01_subnets" {
  value       = module.vpc_01.outpost_subnets
  description = "VPC subnets"
}
