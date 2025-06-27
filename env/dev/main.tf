module "todo_api" {
  source = "../../"

  region       = "ap-northeast-1"
  project_name = "sample-todo-api"
  stage_name   = "v1"
  tags = {
    Project     = "TodoAPI"
    Environment = "demo"
  }
}