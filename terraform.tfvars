aws_region           = "us-east-1"
cluster_name         = "custom-eks-cluster"
worker_desired_capacity = 3
worker_instance_type = "t3.large"
vpc_cidr_block       = "10.1.0.0/16"
public_subnets       = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
