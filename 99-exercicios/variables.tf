# variable "ssh_pub_key" {
#   type        = string
#   description = "chave publica ssh"
# }

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "ec2-mineiro-tf"
}

