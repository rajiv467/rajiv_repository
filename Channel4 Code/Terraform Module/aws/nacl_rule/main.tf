/* NACL rule entries for tcp and udp *only* use nacl_icmp_rule for ICMP
*/

resource "aws_network_acl_rule" "rule" {
  network_acl_id = var.nacl_id

  egress      = var.egress
  protocol    = var.proto
  rule_number = var.rule_no + count.index
  rule_action = var.action
  cidr_block  = element(var.cidr_blocks, count.index)
  from_port   = var.from_port
  to_port     = var.to_port

  # https://github.com/hashicorp/terraform/issues/3888 count must be known before interpolating
  # only required is non-literal blocks
  count = var.cidr_blocks_count
  #count = "${length(var.cidr_blocks)}"
}

/* identify git ref in tfstate - taken from https://github.com/hashicorp/terraform/issues/4234 */
/* REMOVED as it forces each rule to contain a gitversion

# This is used to store the current git state/commit
# in the tfstate file, for future reference
data "template_file" "gitversion" {
    template = "$${local_master}"
    #template = "$${local_master} $${remote_master}"

    vars {
        local_master = "${file("${path.module}/../../.git/refs/heads/master")}"
        #remote_master = "${file("${path.module}/../../.git/refs/remotes/origin/master")}"
    }
}
*/
