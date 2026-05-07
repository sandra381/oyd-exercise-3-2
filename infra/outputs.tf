output "invoke_url" {
    description = "The invoke URL of the API Gateway default stage"
    value       = module.currency_converter.invoke_url
}