/*
output public_ip {
  value       = aws_instance.mineiro-tf.public_ip
}

output public_dns {
  value       = aws_instance.mineiro-tf.public_dns
}

output private_ip {
  value       = aws_instance.mineiro-tf.private_ip
}

output "aws_key_pair"{
    value = aws_key_pair.kp-mineiro-tf
}
*/