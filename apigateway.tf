module "todo_api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  # API
  description   = "API for managing a ToDo list"
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"

  # CORS configuration  
  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Disable custom domain
  create_domain_name = false

  # Routes & Integration(s)
  routes = {
    "POST /create" = {
      integration = {
        type            = "AWS_PROXY"
        subtype         = "StepFunctions-StartExecution"
        credentials_arn = aws_iam_role.api_gateway_role.arn

        request_parameters = {
          StateMachineArn = module.todo_sfn.state_machine_arn
          Input = jsonencode({
            "operation" = "create"
            "payload"   = "$input.json('$')"
          })
        }

        payload_format_version = "1.0"
        timeout_milliseconds   = 12000
      }
    }

    "GET /get" = {
      integration = {
        type            = "AWS_PROXY"
        subtype         = "StepFunctions-StartExecution"
        credentials_arn = aws_iam_role.api_gateway_role.arn

        request_parameters = {
          StateMachineArn = module.todo_sfn.state_machine_arn
          Input = jsonencode({
            "operation" = "get"
            "payload"   = "$input.params()"
          })
        }

        payload_format_version = "1.0"
        timeout_milliseconds   = 12000
      }
    }
  }

  # Stage
  stage_name = var.stage_name

  tags = var.tags
}

# --- IAM Role for API Gateway --- #

resource "aws_iam_role" "api_gateway_role" {
  name = "api-gateway-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "api_gateway_policy" {
  name = "api-gateway-policy"
  role = aws_iam_role.api_gateway_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "states:StartExecution"
        Resource = [
          module.todo_sfn.state_machine_arn
        ]
      }
    ]
  })
}

data "aws_region" "current" {}