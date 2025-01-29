resource "aws_security_group" "instances" {
  name = "${var.app_name}-${var.environment_name}-instance-sg"
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}


resource "aws_security_group_rule" "egress_rule" {
  type = "egress"  
  security_group_id = aws_security_group.instances.id
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
