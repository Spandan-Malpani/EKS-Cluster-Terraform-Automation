# AWS_EKS_Cluster_Setup_with_Terraform

This repository contains a Terraform script designed to create an Amazon EKS (Elastic Kubernetes Service) cluster. The configuration is modular, flexible, and optimized for AWS best practices. This setup is intended to simplify the creation and management of EKS clusters in the AWS environment.

# Description

This project provides an automated solution for deploying and managing an Amazon EKS cluster on AWS using Terraform. It also includes additional functionality to maintain and monitor the EKS cluster lifecycle, ensuring that the cluster is efficiently managed and scaled.

# Architecture Overview

The architecture of the **EKS Cluster Deployment and Management Automation** system can be divided into the following components:

## 1. Automation Controller (GitHub Actions)
- **GitHub Actions** is used to automate the deployment process.
- The workflow is triggered when changes are pushed to the GitHub repository or on-demand via manual triggers.
- The GitHub Actions workflow runs the **Terraform scripts** that provision the EKS cluster and related AWS resources.

## 2. IAM User Credentials
- An **IAM user** is created in the target AWS account where the EKS cluster will be deployed.
- This IAM user is used to authenticate and interact with AWS services, such as EKS, EC2, VPC, and IAM roles.
- Permissions are configured for the IAM user to allow cluster creation, network configuration, and node provisioning.

## 3. Terraform Infrastructure Deployment
The EKS cluster and related resources (VPC, IAM roles, EC2 instances) are defined using **Terraform** configuration files. The deployment includes:
- **Amazon EKS Cluster**: A fully managed Kubernetes environment for running containerized workloads.
- **VPC**: The network environment where the EKS cluster will operate.
- **Subnets**: Public and private subnets within the VPC to isolate and secure the EKS infrastructure.
- **IAM Roles**: The roles required for EKS management and worker node access.
- **Node Groups**: EC2 instances that serve as worker nodes for the EKS cluster.
- **Security Groups**: Configurations to secure network access between resources.

## 4. Managed Add-Ons
The system provides the ability to install optional **EKS Managed Add-Ons**, such as:
- **VPC CNI**: Provides networking capabilities for pods within the EKS cluster.
- **CoreDNS**: Implements DNS resolution for Kubernetes services.
- **Kube-Proxy**: Ensures communication between services within the Kubernetes cluster.
  
These add-ons are installed during the cluster provisioning, based on the user's input for **`eks_addons`**.

## 5. User Inputs via Terraform Variables
The Terraform scripts allow customization of several deployment parameters via **variables**. These include:
- **Account ID**: Specifies the AWS account to deploy the cluster in.
- **Region**: The AWS region where the resources will be provisioned.
- **EKS Cluster Settings**: Such as the cluster name, desired Kubernetes version, node sizes, etc.
- **Managed Add-ons**: The user can choose which add-ons to deploy (e.g., VPC CNI, CoreDNS).
- **S3 Bucket**: Users provide the S3 bucket for storing the Terraform state file.

## 6. Terraform Backend (S3)
The Terraform **backend** configuration is set to store the Terraform state file in an S3 bucket. 
- The backend configuration is set up to manage the Terraform state across different executions, ensuring consistent and accurate deployments.
- Users can configure the backend **S3 bucket** and **region** as part of their deployment process.

![Untitled Diagram](https://github.com/user-attachments/assets/2ab05760-cce3-4b60-93de-64d7f4cc03c4)



# Features

- **Amazon EKS Cluster**: Provisions an EKS cluster with customizable parameters for production-ready deployments.
- **Add-ons**: Includes configurations for essential EKS add-ons such as `vpc-cni`, `coredns`, `kube-proxy`.
- **IAM Roles**: Automatically creates and attaches IAM roles necessary for the add-ons, allowing fine-grained access control.
- **Modular Design**: Organized into modules for EKS, VPC, and IAM roles to promote reusability and clarity.
- **AWS Account ID and Other Variables**: Configured to retrieve the AWS account ID, AMI Type through variables, making the setup adaptable across different accounts and environments.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) for local testing and authentication
- AWS Account with permissions to create IAM roles, EKS, and associated resources
- Basic understanding of EKS and Terraform

 ## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Kishorgujar/EKS_Terraform
   cd EKS_Terraform 

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan**:
   - Review the execution plan:
     ```bash
     terraform plan
     ```
 4. **Configure Variables**:
   - Update `terraform.tfvars` with your preferred configuration, `AWS_ACCOUNT_ID`, 'AMI_Type'
  
 5. **Apply**:
   - Deploy the resources:
     ```bash
     terraform apply
     ```

5. **Access the EKS Cluster**:
   - Configure `kubectl` to use your new cluster:
     ```bash
     aws eks update-kubeconfig --name <eks-cluster-name> --region <region>
     ```

## Customization

- **EKS Add-ons**: You can enable or disable add-ons such as `vpc-cni`, `coredns`, `kube-proxy`.
- **Security Groups and IAM Roles**: Modify or extend these configurations by adjusting the relevant Terraform module configurations.
  
## File Structure
![Screenshot (23)](https://github.com/user-attachments/assets/b47dbeac-4bf8-49f2-94bd-680d9979c8c5)


