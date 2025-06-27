# API Gateway + Step Functions + DynamoDB (Lambdaレス)

このリポジトリは、AWS API Gateway, Step Functions, DynamoDBを利用して、Lambda関数なしでサーバーレスAPIを構築するためのTerraform設定です。

## アーキテクチャ

API GatewayがStep Functionsのステートマシンをトリガーし、そのステートマシンがDynamoDBテーブルと連携してCRUD操作を実行します。

## 利用方法

1. AWSクレデンシャルを設定します。
2. Terraformを初期化します: `terraform init`
3. 設定を適用します: `terraform apply`