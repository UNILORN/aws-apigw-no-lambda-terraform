data "template_file" "create_item_statemachine" {
  template = file("${path.module}/stepfunctions/create-item-statemachine.json")

  vars = {
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.todo_table.name
  }
}

resource "aws_sfn_state_machine" "create_item" {
  name       = "create-item-state-machine"
  role_arn   = aws_iam_role.sfn_role.arn
  definition = data.template_file.create_item_statemachine.rendered
}

data "template_file" "get_item_statemachine" {
  template = file("${path.module}/stepfunctions/get-item-statemachine.json")

  vars = {
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.todo_table.name
  }
}

resource "aws_sfn_state_machine" "get_item" {
  name       = "get-item-state-machine"
  role_arn   = aws_iam_role.sfn_role.arn
  definition = data.template_file.get_item_statemachine.rendered
}
