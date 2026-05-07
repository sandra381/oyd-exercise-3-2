variable "environment" {
    description = "Deployment environment (e.g. dev, prod)"
    type        = string
}
variable "name" {
    description = "Base name for all resources created by this module"
    type        = string
}
variable "memory_size" {
    description = "Amount of memory (MB) allocated to the Lambda function"
    type        = number
    default     = 128
}
variable "architectures" {
    description = "Instruction set architecture for the Lambda function. Valid values: [\"arm64\"] or [\"x86_64\"]"
    type        = list(string)
    default     = ["arm64"]
}