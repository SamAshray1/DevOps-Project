resource "aws_instance" "instance_1" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]
}
