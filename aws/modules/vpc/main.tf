# ------
# VPC
# ------

module "vpc_01" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.system}-${var.env}-vpc-01"
  cidr = "10.0.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  # 商用環境ではこちら。お金がない
  # single_nat_gateway = false
  # one_nat_gateway_per_az = true
}
