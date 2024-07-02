output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_sg_id" {
  value = var.bastion_sg_id
}

output "bastion_eip_cidr" {
  value = var.bastion_eip_cidr
}