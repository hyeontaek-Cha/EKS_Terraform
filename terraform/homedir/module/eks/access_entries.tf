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

# resource "aws_eks_access_entry" "access_entries" {
#   for_each = var.access_entries

#   cluster_name = aws_eks_cluster.eks.name

#   principal_arn = each.value.principal_arn != "" ? each.value.principal_arn : format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
#   kubernetes_groups = each.value.kubernetes_groups
#   type = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "eks_cluster_admin_policy" {
#   for_each = var.access_entries

#   cluster_name  = aws_eks_cluster.eks.name
#   policy_arn    = each.value.policy_associations[var.cluster_name].policy_arn
#   principal_arn = each.value.principal_arn != "" ? each.value.principal_arn : format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)

#   access_scope {
#     namespaces = each.value.policy_associations[var.cluster_name].access_scope.namespaces
#     type       = each.value.policy_associations[var.cluster_name].access_scope.type
#   }

#   depends_on = [aws_eks_cluster.eks]
# }


# data "aws_caller_identity" "current" {}

# data "aws_iam_user" "tf_cht_user" {
#   user_name = "tf-cht"
# }

# locals {
#   root_access_entry = {
#     kubernetes_groups = ["system:masters"]
#     principal_arn     = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
#     policy_associations = {
#       cht-cluster = {
#         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#         access_scope = {
#           namespaces = []
#           type       = "cluster"
#         }
#       }
#     }
#   }

#   tf_cht_access_entry = {
#     kubernetes_groups = ["system:masters"]
#     principal_arn     = data.aws_iam_user.tf_cht_user.arn
#     policy_associations = {
#       cht-cluster = {
#         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#         access_scope = {
#           namespaces = []
#           type       = "cluster"
#         }
#       }
#     }
#   }

#   access_entries = {
#     root   = local.root_access_entry
#     tf_cht = local.tf_cht_access_entry
#   }
# }

# resource "aws_iam_role_policy_attachment" "eks_policy_attachments" {
#   for_each = local.access_entries

#   role       = each.value.principal_arn
#   policy_arn = each.value.policy_associations["cht-cluster"].policy_arn
# }

# resource "kubernetes_config_map" "aws_auth" {
#   depends_on = [aws_eks_cluster.eks]

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = <<-EOT
#     {
#       "mapRoles": [
#         {
#           "rolearn": "${each.value.principal_arn}",
#           "username": "system:node:{{EC2PrivateDNSName}}",
#           "groups": ["system:bootstrappers", "system:nodes"]
#         }
#       ]
#     }
#     EOT
# }






# resource "aws_eks_access_entry" "access_entries" {
#   for_each = var.access_entries
#   cluster_name = aws_eks_cluster.eks.name

#   principal_arn = each.value.principal_arn != "" ? each.value.principal_arn : data.aws_caller_identity.current.arn
#   kubernetes_groups = each.value.kubernetes_groups
#   type = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "eks_cluster_admin_policy" {
#   for_each = var.access_entries

#   cluster_name  = aws_eks_cluster.eks.name
#   policy_arn    = each.value.policy_associations["cht-cluster"].policy_arn
#   principal_arn = each.value.principal_arn != "" ? each.value.principal_arn : data.aws_caller_identity.current.arn

#   access_scope {
#     namespaces = each.value.policy_associations["cht-cluster"].access_scope.namespaces
#     type       = each.value.policy_associations["cht-cluster"].access_scope.type
#   }

#   depends_on = [aws_eks_cluster.eks]
# }

