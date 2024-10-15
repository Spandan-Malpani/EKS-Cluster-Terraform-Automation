provider "aws" {
  region = var.aws_region
}
 
# EKS Cluster Module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
 
  node_groups = {
    worker-group-1 = {
      desired_capacity = var.worker_desired_capacity
      max_capacity     = var.worker_max_capacity
      min_capacity     = var.worker_min_capacity
      instance_type    = var.worker_instance_type
    }
  }
 
  manage_aws_auth = true
}
 
# Output the EKS Cluster endpoint and worker node IAM Role
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
 
output "eks_worker_iam_role" {
  value = module.eks.node_groups["worker-group-1"].iam_role_arn
}
