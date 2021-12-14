data "aws_ami" "ami-ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "ec2-az-a" {
  subnet_id                   = "subnet-0842414f901483088"
  ami                         = data.aws_ami.ami-ubuntu.id
  instance_type               = var.instance_type
  key_name                    = "kp-mineiro"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-019bc97dd2a567acb"]
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "ec2-mineiro-aza"
  }
}
