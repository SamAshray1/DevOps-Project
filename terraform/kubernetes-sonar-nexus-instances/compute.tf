resource "aws_instance" "instance_1" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]
  
  root_block_device {
    volume_size = 25  # Setting the storage to 25 GiB
    volume_type = "gp3"  # General-purpose SSD (recommended), or use "gp2"
  }
}

resource "aws_instance" "instance_2" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]
 
  root_block_device {
    volume_size = 25  # Setting the storage to 25 GiB
    volume_type = "gp3"  # General-purpose SSD (recommended), or use "gp2"
  }
}

resource "aws_instance" "instance_3" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]

  root_block_device {
    volume_size = 25  # Setting the storage to 25 GiB
    volume_type = "gp3"  # General-purpose SSD (recommended), or use "gp2"
  }
}


