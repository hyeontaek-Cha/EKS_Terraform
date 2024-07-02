output "vpc_id" {
  value = aws_vpc.cht_eks_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "bastion_eip_allocation_id" {
  value = aws_eip.bastion_eip.id
}

output "bastion_eip_public_ip" {
  value = aws_eip.bastion_eip.public_ip
}
