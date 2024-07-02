resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [var.node_security_group_id]
  }

  ami_type = "AL2_x86_64"
  instance_types = [var.instance_type]

  depends_on = [
    var.eks_worker_node_policy_attachment_id,
    var.eks_cni_policy_attachment_id,
    var.eks_registry_policy_attachment_id,
    aws_eks_cluster.eks
  ]
  tags = {
    Name = "${var.cluster_name}-node-group" 
  }
}