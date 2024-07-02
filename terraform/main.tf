# AWS Provider 설정
provider "aws" {
  region = var.region
}

# AWS Caller Identity 및 IAM 사용자 데이터
data "aws_caller_identity" "current" {}

data "aws_iam_user" "iam_user" {
  user_name = "tf-test"
}

# VPC 모듈
module "vpc" {
  source          = "./module/vpc"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# 보안 그룹 모듈
module "security_group" {
  source            = "./module/security_group"
  vpc_id            = module.vpc.vpc_id
  bastion_sg_id     = module.security_group.bastion_sg_id
  eks_worker_sg_id  = module.security_group.eks_worker_sg_id
}

# Bastion Host 모듈
module "bastion_host" {
  source                    = "./module/bastion_host"
  vpc_id                    = module.vpc.vpc_id
  public_subnet_id          = element(module.vpc.public_subnets, 0)
  bastion_eip_public_ip     = module.vpc.bastion_eip_public_ip
  bastion_eip_allocation_id = module.vpc.bastion_eip_allocation_id
  private_key_pem           = var.private_key_pem
  key_name                  = var.key_name
  bastion_sg_id             = module.security_group.bastion_sg_id
  eks_worker_sg_id          = module.security_group.eks_worker_sg_id
  bastion_eip_cidr          = format("%s/32", module.vpc.bastion_eip_public_ip)
}

# IAM 모듈
module "iam" {
  source = "./module/iam"
}

# EKS 클러스터 모듈
module "eks" {
  source = "./module/eks"

  # 기본 설정
  cluster_name              = "cht-cluster"
  cluster_version           = "1.27"
  instance_type             = var.instance_type
  desired_capacity          = var.desired_capacity
  max_capacity              = var.max_capacity
  min_capacity              = var.min_capacity
  region                    = var.region
  key_name                  = var.key_name
  private_key_pem           = var.private_key_pem
  user_name                 = data.aws_iam_user.iam_user.user_name

  # 네트워킹 설정
  subnet_ids                = module.vpc.private_subnets
  cluster_security_group_id = module.security_group.eks_cluster_sg_id
  node_security_group_id    = module.security_group.eks_worker_sg_id
  bastion_eip_cidr          = module.bastion_host.bastion_eip_cidr
  bastion_eip_public_ip     = module.vpc.bastion_eip_public_ip

  # IAM 설정
  cluster_iam_role_arn      = module.iam.eks_cluster_role_arn
  cluster_iam_role_name     = module.iam.eks_cluster_role_name
  node_role_arn             = module.iam.eks_node_role_arn
  node_role_name            = module.iam.eks_node_role_name
  account_id                = data.aws_caller_identity.current.account_id

  # 정책 첨부
  eks_cluster_policy_attachment_id     = module.iam.eks_cluster_policy_attachment_id
  AmazonEKSVPCResourceController_id    = module.iam.AmazonEKSVPCResourceController_id
  eks_worker_node_policy_attachment_id = module.iam.eks_worker_node_policy_attachment_id
  eks_cni_policy_attachment_id         = module.iam.eks_cni_policy_attachment_id
  eks_registry_policy_attachment_id    = module.iam.eks_registry_policy_attachment_id

  # 클러스터 접근 설정
  access_entries = {
    root = {
      kubernetes_groups = []
      principal_arn     = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
      policy_associations = {
        cht-cluster = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    tf-test = {
      kubernetes_groups = []
      principal_arn     = data.aws_iam_user.iam_user.arn
      policy_associations = {
        cht-cluster = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }
}