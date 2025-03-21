resource "aws_instance" "trivy" {
  ami             = "ami-011899242bb902164"
  instance_type   = "t2.medium"
  key_name        = "k8s-new"
  security_groups = ["jenkins-sg"]
#  user_data       = file("jenkins-init.sh")

  tags = {
    Name = "Trivy-Server"
  }
}

output "trivy_public_ip" {
  value = aws_instance.trivy.public_ip
}

