# Output value definitions

output "apigwy_url" {
  description = "URL for API Gateway stage"

  value = aws_apigatewayv2_stage.default.invoke_url
}

output "lambda_log_group" {
  description = "Name of the CloudWatch logs group for the lambda function"

  value = aws_cloudwatch_log_group.lambda_logs.id
}

output "apigwy_log_group" {
  description = "Name of the CloudWatch logs group for the lambda function"

  value = aws_cloudwatch_log_group.api_gw.id
}

output "royal_user_pool_id" {
    value = module.royal_cognito.royal_user_pool_id
}

output "royal_user_pool_client_id" {
    value =  module.royal_cognito.royal_user_pool_client_id
}

output "royal_cognito_user_pool_name" {
    value =  module.royal_cognito.royal_cognito_user_pool_name
}

output "royal_cognito_user_pool_arn" {
    value =  module.royal_cognito.royal_cognito_user_pool_arn
}
output "royal_cognito_user_pool_endpoint" {
    value =  module.royal_cognito.royal_cognito_user_pool_endpoint
}

output "get_lambda_arn" {
  description = "arn of get lambda"

  value = aws_lambda_function.apigw_lambda_ddb_get.arn
}

output "delete_lambda_arn" {
  description = "arn of delete lambda"

  value = aws_lambda_function.apigw_lambda_ddb_delete.arn
}