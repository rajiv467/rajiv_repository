/* Test EC2 instance 
*/

resource "aws_instance" "mod" {
  ami                                  = var.ami_id
  associate_public_ip_address          = true
  disable_api_termination              = false
  iam_instance_profile                 = var.profile
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.type
  key_name                             = var.key_pair
  subnet_id                            = element(split(",", var.subnet_list), count.index)
  user_data                            = var.user_data
  vpc_security_group_ids               = split(",", var.sg_list)

  tags = {
    Name        = "${var.name}-inst${var.name_suffix}"
    Environment = var.environment
    Farm        = var.farm
    Owner       = var.owner
    Project     = var.project
    GeneratedBy = "terraform"
  }

  count = var.count
}

/* identify git ref in tfstate - taken from https://github.com/hashicorp/terraform/issues/4234 */

# This is used to store the current git state/commit
# in the tfstate file, for future reference
data "template_file" "gitversion" {
  template = "$${local_master}"

  #template = "$${local_master} $${remote_master}"

  vars = {
    local_master = file("${path.module}/../../.git/refs/heads/master")
  }
  #remote_master = "${file("${path.module}/../../.git/refs/remotes/origin/master")}"
}

