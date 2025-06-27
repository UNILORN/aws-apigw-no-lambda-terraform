variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "TodoAPI"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "TodoList"
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