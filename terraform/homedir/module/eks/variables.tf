variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
}

variable "cluster_iam_role_arn" {
  type = string
}

variable "cluster_iam_role_name" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "node_role_name" {
  type = string
}

variable "cluster_security_group_id" {
  type = string
}

variable "node_security_group_id" {
  type = string
}

variable "bastion_eip_cidr" {
  description = "The CIDR block for the bastion host's EIP"
  type        = string
}

variable "region" {
  description = "The region where the EKS cluster is located"
  type        = string
}

variable "private_key_pem" {
  description = "Path to the private key pem file"
  sensitive   = true
  type        = string
}

variable "bastion_eip_public_ip" {
  description = "The public IP of the bastion host"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type = string
}

variable "eks_cluster_policy_attachment_id" {
  description = "The ID of the EKS cluster policy attachment"
  type        = string
}

variable "AmazonEKSVPCResourceController_id" {
  description = "The ID of the Amazon EKS VPC Resource Controller policy attachment"
  type        = string
}

variable "eks_worker_node_policy_attachment_id" {
  description = "The ID of the EKS worker node policy attachment"
  type        = string
}

variable "eks_cni_policy_attachment_id" {
  description = "The ID of the Amazon EKS CNI policy attachment"
  type        = string
}

variable "eks_registry_policy_attachment_id" {
  description = "The ID of the Amazon EC2 Container Registry ReadOnly policy attachment"
  type        = string
}

variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}


variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to enable cluster creator admin permissions"
  type        = bool
  default     = false
}

variable "access_entries" {
  description = "A map of access entries to create"
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        namespaces = list(string)
        type       = string
      })
    }))
  }))
}