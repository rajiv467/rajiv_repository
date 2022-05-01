/* NACL rule entries for icmp *only* use nacl_rule for TCP and UDP
*/

resource "aws_network_acl_rule" "rule" {
  network_acl_id = var.nacl_id

  egress      = var.egress
  protocol    = "icmp"
  rule_number = var.rule_no + count.index
  rule_action = var.action
  cidr_block  = element(var.cidr_blocks, count.index)
  icmp_type   = var.icmp_type
  icmp_code   = var.icmp_code

  count = var.cidr_blocks_count
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
