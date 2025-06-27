module "todo_sfn" {
  source = "terraform-aws-modules/step-functions/aws"

  name       = "todo-state-machine"
  definition = templatefile("${path.module}/stepfunctions/statemachine.json", {
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.todo_table.name
  })

  service_integrations = {
    dynamodb = {
      dynamodb = [aws_dynamodb_table.todo_table.arn]
    }
  }

  tags = var.tags
}
