resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

locals {
  account_id  = var.account_id
  environment = terraform.workspace
}
# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name               = "${var.environment}-eks-role-${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  lifecycle {
    #   prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name = var.eks_role_tag
  })
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Policy Attachments for EKS Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  lifecycle {
    #   prevent_destroy = true
  }
}

# IAM Role for Node Groups
resource "aws_iam_role" "node_role" {
  name               = "${var.environment}-node-role-${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
  lifecycle {
    #   prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name = var.node_role_tag
  })
}

data "aws_iam_policy_document" "node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Policy Attachments for Node Role
resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  lifecycle {
    #   prevent_destroy = true
  }
}


resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  lifecycle {
    #   prevent_destroy = true
  }
}

# Policy for Allowing EKS to Pass the Node Role
resource "aws_iam_policy" "allow_pass_role" {
  name        = "${var.environment}-AllowPassRole-${random_string.suffix.result}"
  description = "Allows EKS role to pass Node role"
  lifecycle {
    #   prevent_destroy = true
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.node_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pass_role_attachment" {
  policy_arn = aws_iam_policy.allow_pass_role.arn
  role       = aws_iam_role.eks_role.name
  lifecycle {
    #   prevent_destroy = true
  }
}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "AWS_LoadBalancer_Controller_Policy" {
  name        = "${var.environment}-AWSLoadBalancerControllerIAMPolicy-${random_string.suffix.result}"
  path        = "/"
  description = "AWSLoadBalancerControllerIAMPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["iam:CreateServiceLinkedRole"]
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:Create*",
          "elasticloadbalancing:Delete*",
          "elasticloadbalancing:Modify*",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for Load Balancer Controller
resource "aws_iam_role" "EKS_LB_CNI_Role" {
  name               = "${var.environment}-lb-cni-role-${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.EKS_VPC_CNI_assume_role_policy_LB.json

  tags = merge(var.tags, {
    Name = "${var.environment}-LB-CNI-Role"
  })
}

data "aws_iam_policy_document" "EKS_VPC_CNI_assume_role_policy_LB" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticloadbalancing.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "EKS_LB_CNI_Role_Attachment" {
  policy_arn = aws_iam_policy.AWS_LoadBalancer_Controller_Policy.arn
  role       = aws_iam_role.EKS_LB_CNI_Role.name
}
