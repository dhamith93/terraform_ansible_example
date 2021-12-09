terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags_name = "prod-internal-servers"
}

resource "aws_vpc" "internal_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.tags_name}"
  }
}

resource "aws_internet_gateway" "internal-gw" {
  vpc_id = aws_vpc.internal_vpc.id
  tags = {
    Name = "${local.tags_name}"
  }
}

resource "aws_route_table" "internal-route-table" {
  vpc_id = aws_vpc.internal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internal-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.internal-gw.id
  }

  tags = {
    Name = "${local.tags_name}"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.internal_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.tags_name}"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.internal-route-table.id
}

resource "aws_security_group" "security_group_1" {
  name   = "db-security-group"
  vpc_id = aws_vpc.internal_vpc.id

  ingress {
    description = "Database"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.tags_name}"
  }
}

resource "aws_security_group" "security_group_2" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.internal_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.tags_name}"
  }
}

module "db_server" {
  source = "./modules/server"
  subnet_id = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.100"]
  security_group_ids = [aws_security_group.security_group_1.id]
  tag_name = "${local.tags_name}"

  image_id = var.image_id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
}

module "uat_server" {
  source = "./modules/server"
  subnet_id = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.101"]
  security_group_ids = [aws_security_group.security_group_2.id]
  tag_name = "${local.tags_name}"

  image_id = var.image_id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
}

module "prod_server" {
  source = "./modules/server"
  subnet_id = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.102"]
  security_group_ids = [aws_security_group.security_group_2.id]
  tag_name = "${local.tags_name}"

  image_id = var.image_id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
}

module "demo_server" {
  source = "./modules/server"
  subnet_id = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.103"]
  security_group_ids = [aws_security_group.security_group_2.id]
  tag_name = "${local.tags_name}"

  image_id = var.image_id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.key_name
}