data "aws_ami" "ami-ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "ec2-az-a" {
  subnet_id                   = aws_subnet.subnet-az-a.id
  ami                         = data.aws_ami.ami-ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key.kp-mineiro-us
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "ec2-mineiro-aza"
  }
}
