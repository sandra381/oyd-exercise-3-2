variable "aws_region" {
    description = "AWS region where resources will be deployed"
    type        = string
    default     = "us-east-1"
}
variable "environment" {
    description = "Deployment environment (e.g. dev, prod)"
    type        = string
}
variable "name" {
    description = "Base name for all resources"
    type        = string
}
variable "memory_size" {
    description = "Amount of memory (MB) allocated to the Lambda function"
    type        = number
    default     = 128
}
variable "architectures" {
    description = "Instruction set architecture for Lambda. Valid values: [\"arm64\"] or [\"x86_64\"]"
    type        = list(string)
    default     = ["arm64"]
}