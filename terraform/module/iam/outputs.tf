output "eks_cluster_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy_attachment.id
}

output "AmazonEKSVPCResourceController_id" {
  value = aws_iam_role_policy_attachment.AmazonEKSVPCResourceController.id
}

output "eks_worker_node_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.eks_worker_node_policy_attachment.id
}

output "eks_cni_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.eks_cni_policy_attachment.id
}

output "eks_registry_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.eks_registry_policy_attachment.id
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_role_name" {
  value = aws_iam_role.eks_cluster_role.name
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_node_role_name" {
  value = aws_iam_role.eks_node_role.name
}
