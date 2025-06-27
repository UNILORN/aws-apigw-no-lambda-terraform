# API Gateway outputs
output "api_id" {
  description = "The API identifier"
  value       = module.todo_api_gateway.api_id
}

output "api_endpoint" {
  description = "URI of the API, of the form https://{api-id}.execute-api.{region}.amazonaws.com"
  value       = module.todo_api_gateway.api_endpoint
}

output "api_arn" {
  description = "The ARN of the API"
  value       = module.todo_api_gateway.api_arn
}

output "stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.todo_api_gateway.stage_invoke_url
}

# Step Functions outputs
output "state_machine_arn" {
  description = "The ARN of the Step Functions state machine"
  value       = module.todo_sfn.state_machine_arn
}

# DynamoDB outputs
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.todo_table.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.todo_table.arn
}

# Test commands
output "create_item_test_command" {
  description = "Curl command to test creating an item"
  value       = "curl -X POST ${module.todo_api_gateway.stage_invoke_url}/create -H 'Content-Type: application/json' -d '{\"id\":\"test-1\",\"title\":\"Test Task\",\"completed\":false}'"
}

output "get_item_test_command" {
  description = "Curl command to test getting an item"
  value       = "curl -X GET '${module.todo_api_gateway.stage_invoke_url}/get?id=test-1'"
}
