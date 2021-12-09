terraform {
  required_version = ">= 0.15"
}

resource "aws_network_interface" "server-nic" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = var.security_group_ids

  tags = {
    Name = var.tag_name
  }
}

resource "aws_instance" "server" {
  ami               = var.image_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name

  depends_on = [
    aws_network_interface.server-nic
  ]

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.server-nic.id
  }

  tags = {
    Name = var.tag_name
  }
}