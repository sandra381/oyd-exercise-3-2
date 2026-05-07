output "invoke_url" {
  description = "The invoke URL of the API Gateway default stage"
  value       = aws_apigatewayv2_stage.default.invoke_url
}