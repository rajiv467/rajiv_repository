output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "role_arn" {
  value = aws_iam_role.lambda.arn
}

output "function_version" {
  value = aws_lambda_function.lambda.version
}

output "latest_alias_name" {
  value = aws_lambda_alias.lambda_latest.*.name
}

