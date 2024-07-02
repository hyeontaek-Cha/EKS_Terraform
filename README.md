# EKS_Terraform
Terraform EKS 클러스터 구축
Tree
│   .terraform.lock.hcl
│   main.tf
│   terraform.log
│   terraform.tfstate
│   terraform.tfstate.backup
│   terraform.tfvars
│   variables.tf
│
├───module
│   ├───bastion_host
│   │       aws_configure.sh
│   │       data.tf
│   │       install_awscli2_kubectl.sh
│   │       main.tf
│   │       outputs.tf
│   │       variables.tf
│   │
│   ├───eks
│   │       access_entries.tf
│   │       eks_cluster.tf
│   │       eks_node_group.tf
│   │       outputs.tf
│   │       variables.tf
│   │
│   ├───iam
│   │       main.tf
│   │       outputs.tf
│   │
│   ├───security_group
│   │       bastion_sg.tf
│   │       eks_cluster_sg.tf
│   │       eks_worker_sg.tf
│   │       outputs.tf
│   │       variables.tf
│   │
│   └───vpc
│           main.tf
│           outputs.tf
│           variables.tf