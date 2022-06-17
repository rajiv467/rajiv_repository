resource "aws_security_group" "eks" {
  name_prefix = "${var.cluster_name}-security-group"
  vpc_id = module.vpc.vpc_id
  description = "security group for eks cluser ${var.cluster_name} managed by terraform"

  # all local ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }

  # all internal sg
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  # all egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
