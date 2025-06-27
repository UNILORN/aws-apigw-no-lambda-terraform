module "todo_api" {
    source = "../../"

    region               = "ap-northeast-1"
    api_name            = "TodoAPI"
    dynamodb_table_name = "TodoList"
    stage_name          = "v1"
    tags                = {
        Project     = "TodoAPI"
        Environment = "demo"
    }
}