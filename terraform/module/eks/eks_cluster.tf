resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.cluster_iam_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_public_access  = false
    endpoint_private_access = true
    # public_access_cidrs     = [var.bastion_eip_cidr]
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  version = var.cluster_version

  depends_on = [
    var.eks_cluster_policy_attachment_id,
    var.AmazonEKSVPCResourceController_id
  ]
}

data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

resource "null_resource" "update_kubeconfig" {
  provisioner "remote-exec" {
    inline = [
      "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name} --kubeconfig /home/ec2-user/.kube/config > /home/ec2-user/kubeconfig.log 2>&1",
      "sudo mkdir -p /root/.kube",
      "sudo cp /home/ec2-user/.kube/config /root/.kube/config",
      "sudo chown root:root /root/.kube/config",
      "sudo chmod 600 /root/.kube/config"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_pem)
    host        = var.bastion_eip_public_ip
  }
  depends_on = [aws_eks_cluster.eks, aws_eks_node_group.eks_nodes]
}