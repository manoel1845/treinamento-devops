output "public_ip" {
  value = aws_instance.ec2-az-a.public_ip
}

output "public_dns" {
  value = aws_instance.ec2-az-a.public_dns
}

output "private_ip" {
  value = aws_instance.ec2-az-a.private_ip
}