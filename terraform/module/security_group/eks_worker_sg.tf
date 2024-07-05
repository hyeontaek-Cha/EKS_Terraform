resource "aws_security_group" "eks_worker_sg" {
  name_prefix = "eks-worker-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-sg"
  }
}

# 특정 CIDR 블록에서 EKS 워커 노드로의 인바운드 트래픽을 허용
resource "aws_security_group_rule" "eks_worker_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_sg.id
  cidr_blocks              = ["10.200.0.0/16"]
}
