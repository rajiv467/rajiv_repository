/* Until the provider block works in modules GH:4789 and GH:1819 we need to run these as local execs */
# this does not work as expected
/*resource "template_file" "route" {
    template = <<EOF
command = "aws ec2 create-route --route-table-id ${route_table_id} --destination-cidr-block ${dest_cidr} --${target_type} ${target_value} --profile ${profile}"
EOF
    vars {
        route_table_id = "${element(var.route_table_ids, count.index)}"
        dest_cidr = "${var.destination_cidr}"
        target_type = "${var.target_type}"
        target_value = "${var.target_value}"
        profile = "${var.profile}"
    }

    provisioner "local-exec" {
        command = "${replace(template_file.ds.rendered,"\n","")}"
    }

    count = "${length(var.route_table_ids)}"
}*/
#this does not work as expected either (no support for lists)
/*resource "template_file" "route" {
    template = "aws ec2 create-route --route-table-id ${rt_id} --destination-cidr-block ${dest_cidr} --${target_type} ${target_value} --profile ${profile}"

    vars {
        rt_id = "${element(var.rt_ids, count.index)}"
        dest_cidr = "${var.destination_cidr}"
        target_type = "${var.target_type}"
        target_value = "${var.target_value}"
        profile = "${var.profile}"
    }

    count = "${length(split(",", var.rt_ids))}"
}

resource "null_resource" "route" {

    triggers = {
        rt_id = "${join(",", var.rt_ids)}"
    }

    provisioner "local-exec" {
        #command = "aws ec2 create-route --route-table-id ${self.triggers.rt_id} --destination-cidr-block ${var.destination_cidr} --${var.target_type} ${var.target_value} --profile ${var.profile}"
        command = "echo ${element(template_file.route.*.rendered, count.index)}"
    } 

    count = "${var.rt_count}"
}*/
# this does not work (no support for count)
/*data "template_file" "route" {
    template = "aws ec2 create-route --route-table-id $${rt_id} --destination-cidr-block $${dest_cidr} --$${target_type} $${target_value} --profile $${profile}"

    vars {
        rt_id = "${element(var.rt_ids, count.index)}"
        dest_cidr = "${var.destination_cidr}"
        target_type = "${var.target_type}"
        target_value = "${var.target_value}"
        profile = "${var.profile}"
    }

    count = "${length(split(",", var.rt_ids))}"
}*/
