resource "aws_eks_access_entry" "access_entries" {
  for_each = var.access_entries
  cluster_name = aws_eks_cluster.eks.name

  principal_arn = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_cluster_admin_policy" {
  for_each = var.access_entries

  cluster_name  = aws_eks_cluster.eks.name
  policy_arn    = each.value.policy_associations[var.cluster_name].policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    namespaces = each.value.policy_associations[var.cluster_name].access_scope.namespaces
    type       = each.value.policy_associations[var.cluster_name].access_scope.type
  }

  depends_on = [aws_eks_cluster.eks]
}