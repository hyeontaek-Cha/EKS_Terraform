output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_node_group_id" {
  value = aws_eks_node_group.eks_nodes.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_node_group_arn" {
  value = aws_eks_node_group.eks_nodes.arn
}

output "instance_type" {
  description = "The instance type for the EKS node group."
  value       = var.instance_type
}

output "desired_capacity" {
  description = "The desired capacity of the EKS node group."
  value       = var.desired_capacity
}

output "max_capacity" {
  description = "The maximum capacity of the EKS node group."
  value       = var.max_capacity
}

output "min_capacity" {
  description = "The minimum capacity of the EKS node group."
  value       = var.min_capacity
}

output "cluster_security_group_id" {
  value = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}