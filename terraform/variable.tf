variable "region" {
  type = string
  default = "us-east-1"
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

variable "key_path" {
  type = string
  default = "/Users/dhamith93/Desktop/dhamith93-us-east-new.cer"
}