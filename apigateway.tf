resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "TodoAPI"
  description = "API for managing a ToDo list"
}

# --- Create Item --- #

resource "aws_api_gateway_resource" "create_item_resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "create"
}

resource "aws_api_gateway_method" "create_item_method" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.create_item_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_item_integration" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.create_item_resource.id
  http_method = aws_api_gateway_method.create_item_method.http_method

  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:states:action/StartExecution"
  credentials             = aws_iam_role.api_gateway_role.arn

  request_templates = {
    "application/json" = <<EOF
{
  "stateMachineArn": "${aws_sfn_state_machine.create_item.id}",
  "input": "$util.escapeJavaScript($input.json('$'))"
}
EOF
  }
}

# --- Get Item --- #

resource "aws_api_gateway_resource" "get_item_resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "get_item_method" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.get_item_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_item_integration" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.get_item_resource.id
  http_method = aws_api_gateway_method.get_item_method.http_method

  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:states:action/StartExecution"
  credentials             = aws_iam_role.api_gateway_role.arn

  request_templates = {
    "application/json" = <<EOF
{
  "stateMachineArn": "${aws_sfn_state_machine.get_item.id}",
  "input": "$util.escapeJavaScript($input.json('$'))"
}
EOF
  }
}

# --- IAM Role for API Gateway --- #

resource "aws_iam_role" "api_gateway_role" {
  name = "api-gateway-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_gateway_policy" {
  name = "api-gateway-policy"
  role = aws_iam_role.api_gateway_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "states:StartExecution",
      "Resource": [
        "${aws_sfn_state_machine.create_item.id}",
        "${aws_sfn_state_machine.get_item.id}"
      ]
    }
  ]
}
EOF
}

# --- Deployment ---

resource "aws_api_gateway_deployment" "todo_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_item_integration,
    aws_api_gateway_integration.get_item_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  stage_name  = "v1"
}

data "aws_region" "current" {}
