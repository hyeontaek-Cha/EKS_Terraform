output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "eks_worker_sg_id" {
  value = aws_security_group.eks_worker_sg.id
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}
