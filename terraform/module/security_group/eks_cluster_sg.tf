resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

# Bastion 호스트에서 EKS 클러스터 API 서버로 통신
resource "aws_security_group_rule" "bastion_to_eks_cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = var.bastion_sg_id
}

# EKS 워커 노드에서 EKS 클러스터 API 서버로 통신
resource "aws_security_group_rule" "worker_to_eks_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id
}

# Bastion 호스트에서 EKS 클러스터로의 SSH 접근
resource "aws_security_group_rule" "bastion_to_auto_eks_cluster" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = var.eks_cluster_security_group_id
  source_security_group_id = var.bastion_sg_id
}