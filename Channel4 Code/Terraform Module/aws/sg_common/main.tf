/* Common Security Groups
*/

resource "aws_security_group" "ssh" {
  name        = "ssh-sg${var.name_suffix}"
  description = "SSH access from known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["piksel"],
      var.cidrs["piksel_jo_hide"],
      var.cidrs["c4_corp"],
      var.cidrs["c4_corp_wifi"],
      var.cidrs["c4_corp_dx"],
      var.vpc_cidr,
    ]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "ssh-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "ssh_jump" {
  name        = "sshjump-sg${var.name_suffix}"
  description = "SSH access inbound and outbound to known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["piksel"],
      var.cidrs["c4_corp"],
      var.cidrs["c4_corp_wifi"],
      var.cidrs["c4_corp_dx"],
      var.vpc_cidr,
    ]
  }

  # allow outbound ssh
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "sshjump-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "rdp" {
  name        = "rdp-sg${var.name_suffix}"
  description = "RDP access from known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["piksel"],
      var.cidrs["piksel_jo_hide"],
      var.cidrs["c4_corp"],
      var.cidrs["c4_corp_wifi"],
      var.cidrs["c4_corp_dx"],
      var.vpc_cidr,
    ]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "rdp-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "monitoring" {
  name        = "monitoring-sg${var.name_suffix}"
  description = "common monitoring access from known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5666
    to_port   = 5666
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["nmadmin_ew1_core"],
      var.cidrs["piksel"],
    ]
  }

  ingress {
    from_port = 161
    to_port   = 161
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["nmadmin_ew1_core"],
      var.cidrs["piksel"],
    ]
  }

  ingress {
    from_port = 161
    to_port   = 161
    protocol  = "udp"

    cidr_blocks = [
      var.cidrs["nmadmin_ew1_core"],
      var.cidrs["piksel"],
    ]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "monitoring-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "http" {
  name        = "http-sg${var.name_suffix}"
  description = "HTTP(S) access from known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["piksel"],
      var.cidrs["c4_corp"],
      var.cidrs["c4_corp_wifi"],
      var.cidrs["c4_onprem"],
      var.cidrs["devopstoolsshared"],
      var.cidrs["devopstoolsdev"],
      var.cidrs["devopstoolsprod"],
      var.cidrs["c4_corp_dx"],
      var.cidrs["c4_corp_nw"],
      var.vpc_cidr,
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      var.cidrs["piksel"],
      var.cidrs["c4_corp"],
      var.cidrs["c4_corp_wifi"],
      var.cidrs["c4_onprem"],
      var.cidrs["devopstoolsshared"],
      var.cidrs["devopstoolsdev"],
      var.cidrs["devopstoolsprod"],
      var.cidrs["c4_corp_dx"],
      var.cidrs["c4_corp_nw"],
      var.cidrs["piksel_https_hide"],
      var.vpc_cidr,
    ]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "http-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "http_elb" {
  name        = "httpelb-sg${var.name_suffix}"
  description = "open HTTP(S) access for ELBs to instances using the http SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # health checks and forward traffic (secured to any instance using the http SG)
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.http.id]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.http.id]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "httpelb-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "dns" {
  name        = "dns-sg${var.name_suffix}"
  description = "DNS access from known CIDR blocks and outbound to all"
  vpc_id      = var.vpc_id

  # restrict queries to known networks
  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"

    cidr_blocks = concat(
      [
        var.cidrs["piksel"],
        var.cidrs["c4_corp"],
        var.cidrs["c4_corp_wifi"],
        var.cidrs["c4_corp_dx"],
        var.cidrs["c4_corp_nw"],
        var.cidrs["c4_th_dns"],
        var.cidrs["piksel_ns_hide"],
        var.vpc_cidr,
      ],
      var.additional_vpc_ipv4_cidr_blocks
    )
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "udp"

    cidr_blocks = concat(
      [
        var.cidrs["piksel"],
        var.cidrs["c4_corp"],
        var.cidrs["c4_corp_wifi"],
        var.cidrs["c4_corp_dx"],
        var.cidrs["c4_corp_nw"],
        var.cidrs["c4_th_dns"],
        var.cidrs["piksel_ns_hide"],
        var.vpc_cidr,
      ],
      var.additional_vpc_ipv4_cidr_blocks
    )
  }

  # allow outbound to query any other dns servers
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "dns-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "ntp" {
  name        = "ntp-sg${var.name_suffix}"
  description = "NTP access from known CIDR blocks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  # allow outbound queries to other ntp servers
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "ntp-sg${var.name_suffix}"
    },
  )
}

resource "aws_security_group" "egress" {
  name        = "egress-sg${var.name_suffix}"
  description = "Common egress rules for VPC instances"
  vpc_id      = var.vpc_id

  # HTTP(S) to anywhere
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS
  egress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
      "8.8.8.8/32",
      "8.8.4.4/32",
    ]
  }

  egress {
    from_port = 53
    to_port   = 53
    protocol  = "udp"

    cidr_blocks = [
      var.vpc_cidr,
      "8.8.8.8/32",
      "8.8.4.4/32",
    ]
  }

  # NTP
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "egress-sg${var.name_suffix}"
    },
  )
}

