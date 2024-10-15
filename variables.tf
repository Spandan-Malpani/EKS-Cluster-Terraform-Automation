variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-west-2"  # Can be overridden
}
 
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"  # Can be overridden
}
 
variable "cluster_version" {
  description = "Version of Kubernetes to use"
  type        = string
  default     = "1.27"
}
 
variable "worker_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}
 
variable "worker_min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}
 
variable "worker_max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
 
variable "worker_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}
 
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}
 
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
 
variable "aws_azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
 
variable "public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
