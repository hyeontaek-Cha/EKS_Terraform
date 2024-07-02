variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "bastion_eip_allocation_id" {
  type = string
}

variable "bastion_eip_public_ip" {
  type = string
}

variable "private_key_pem" {
  description = "The private key PEM for the bastion host"
  type        = string
  sensitive = true
}

variable "bastion_sg_id" {
  type = string
}

variable "eks_worker_sg_id" {
  type = string
}

variable "bastion_eip_cidr" {
  description = "The CIDR block for the bastion host's EIP"
  type        = string
}