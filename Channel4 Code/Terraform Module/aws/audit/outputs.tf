output "mstwarn_topic_arn" {
  value = aws_sns_topic.mstwarn_topic.arn
}

output "mstcrit_topic_arn" {
  value = aws_sns_topic.mstcrit_topic.arn
}

output "mstwarnprod_topic_arn" {
  value = aws_sns_topic.mstwarnprod_topic.arn
}

output "mstcritprod_topic_arn" {
  value = aws_sns_topic.mstcritprod_topic.arn
}

