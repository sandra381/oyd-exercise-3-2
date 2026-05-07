resource "aws_iam_role" "lambda" {
    name = "${var.name}-${var.environment}-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "lambda.amazonaws.com"
            }
        }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role       = aws_iam_role.lambda.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "this" {
    function_name    = "${var.name}-${var.environment}"
    role             = aws_iam_role.lambda.arn
    runtime          = "nodejs22.x"
    handler          = "index.handler"
    filename         = "${path.module}/../../../app/function.zip"
    source_code_hash = filebase64sha256("${path.module}/../../../app/function.zip")
    architectures    = var.architectures
    memory_size      = var.memory_size

    environment {
        variables = {
        COMPUTE_TYPE = "lambda"
        }
    }
}
resource "aws_apigatewayv2_api" "this" {
    name          = "${var.name}-${var.environment}-api"
    protocol_type = "HTTP"
}
resource "aws_apigatewayv2_integration" "lambda" {
    api_id                 = aws_apigatewayv2_api.this.id
    integration_type       = "AWS_PROXY"
    integration_uri        = aws_lambda_function.this.invoke_arn
    payload_format_version = "2.0"
}
resource "aws_apigatewayv2_route" "get_rates" {
    api_id    = aws_apigatewayv2_api.this.id
    route_key = "GET /rates"
    target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "post_convert" {
    api_id    = aws_apigatewayv2_api.this.id
    route_key = "POST /convert"
    target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_apigatewayv2_stage" "default" {
    api_id      = aws_apigatewayv2_api.this.id
    name        = "$default"
    auto_deploy = true
}
resource "aws_lambda_permission" "apigw" {
    statement_id  = "AllowAPIGatewayInvoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.this.function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}