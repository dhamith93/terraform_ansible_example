variable "subnet_id" {
  type = string
}

variable "private_ips" {
  type = set(string)
}

variable "security_group_ids" {
  type = set(string)
}

variable "tag_name" {
  type = string
}

variable "image_id" {
  type = string
  default = "ami-00e87074e52e6c9f9" # CentOS Linux 7
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "availability_zone" {
  type = string
  default = "us-east-1a"
}

variable "key_name" {
  type = string
  default = "dhamith93-us-east-new"
}