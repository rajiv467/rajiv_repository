output "cloudtrail_arn" {
  value = aws_cloudtrail.trail.arn
}

/*output "cloudtrail_log_group_arn" {
    value = "${aws_cloudwatch_log_group.trail.arn}"
}*/
/*output "config_id" {
    value = "${null_resource.config_service.id}"
}*/
