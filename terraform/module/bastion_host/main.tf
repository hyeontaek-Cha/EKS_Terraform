resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.AL2.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = var.bastion_eip_allocation_id
}

resource "null_resource" "bastion_provisioner" {
  depends_on = [aws_eip_association.bastion_eip_assoc]

  provisioner "local-exec" {
    command = "echo 'Provisioning Bastion Host'"
  }

  provisioner "file" {
    source      = var.private_key_pem
    destination = "/home/ec2-user/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = var.bastion_eip_public_ip
      private_key = file(var.private_key_pem)
    }
  }

  provisioner "file" {
    source      = "${path.module}/install_awscli2_kubectl.sh"
    destination = "/home/ec2-user/install_awscli2_kubectl.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = var.bastion_eip_public_ip
      private_key = file(var.private_key_pem)
    }
  }

  provisioner "file" {
    source      = "${path.module}/aws_configure.sh"
    destination = "/home/ec2-user/aws_configure.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = var.bastion_eip_public_ip
      private_key = file(var.private_key_pem)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ec2-user/${var.key_name}.pem",
      "sudo yum install -y dos2unix",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = var.bastion_eip_public_ip
      private_key = file(var.private_key_pem)
    }
  }
}

resource "null_resource" "install_awscli2_kubectl" {
  depends_on = [null_resource.bastion_provisioner]

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/install_awscli2_kubectl.sh",
      "chmod +x /home/ec2-user/aws_configure.sh",
      "sudo dos2unix /home/ec2-user/install_awscli2_kubectl.sh",
      "sudo dos2unix /home/ec2-user/aws_configure.sh",
      "/home/ec2-user/install_awscli2_kubectl.sh",
      "/home/ec2-user/aws_configure.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = var.bastion_eip_public_ip
      private_key = file(var.private_key_pem)
    }
  }
}