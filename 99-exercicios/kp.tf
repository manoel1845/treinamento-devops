resource "aws_key_pair" "kp-mineiro-us" {
  key_name   = "kp-mineiro-us"
  public_key = var.ssh_pub_key
}
