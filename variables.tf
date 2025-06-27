
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-apigateway-no-lambda"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "v1"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Project     = "TodoAPI"
    Environment = "demo"
  }
}