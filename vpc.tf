module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0"
 
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr_block
  azs                  = var.aws_azs
  public_subnets       = var.public_subnets
  enable_dns_support   = true
  enable_dns_hostnames = true
}
