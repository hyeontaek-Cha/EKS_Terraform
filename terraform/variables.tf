variable "region" {
  type = string
  default = "ap-northeast-2"
}
variable "key_name" {
  description = "The name of the key pair"
}

variable "private_key_pem" {
  description = "Path to the private key pem file"
  sensitive = true
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    { cidr_block = "10.200.100.0/24", availability_zone = "ap-northeast-2a", name = "cht-eks-public-subnet-1" },
    { cidr_block = "10.200.101.0/24", availability_zone = "ap-northeast-2c", name = "cht-eks-public-subnet-2" }
  ]
}

variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    { cidr_block = "10.200.10.0/24", availability_zone = "ap-northeast-2a", name = "cht-eks-private-subnet-1" },
    { cidr_block = "10.200.11.0/24", availability_zone = "ap-northeast-2c", name = "cht-eks-private-subnet-2" }
  ]
}

variable "instance_type" {
  description = "The instance type for the EKS node group."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired capacity of the EKS node group."
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "The maximum capacity of the EKS node group."
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "The minimum capacity of the EKS node group."
  type        = number
  default     = 1
}