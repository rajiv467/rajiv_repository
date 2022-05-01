output "instance_id" {
  value = join(",", aws_instance.mod[0].id)
}

output "subnet_id" {
  value = join(",", aws_instance.mod[0].subnet_id)
}

output "public_ip" {
  value = join(",", aws_instance.mod[0].public_ip)
}

output "private_ip" {
  value = join(",", aws_instance.mod[0].private_ip)
}

