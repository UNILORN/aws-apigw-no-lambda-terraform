# API Gateway + Step Functions + DynamoDB (Lambdaレス)

このリポジトリは、AWS API Gateway, Step Functions, DynamoDBを利用して、Lambda関数なしでサーバーレスAPIを構築するためのTerraform設定です。terraform-aws-modules/terraform-aws-apigateway-v2 モジュールを使用してAPI Gateway v2 (HTTP API)で構築されています。

## 概要

このプロジェクトは、API Gatewayの直接統合機能を活用し、リクエストをStep Functionsのステートマシンに連携させることで、Lambdaを介さずにビジネスロジックを実行するアーキテクチャを実現します。これにより、管理するコンポーネントを減らし、潜在的なコストを削減できます。

## アーキテクチャ

このアーキテクチャは以下のコンポーネントで構成されています。

```
クライアント
    │
    v
┌───────────────────┐
│ API Gateway v2    │
│  - /create (POST) │
│  - /get (GET)     │
└───────────────────┘
    │
    v
┌───────────────────┐
│ Step Functions    │
│ (ステートマシン)  │
└───────────────────┘
    │
    v
┌───────────────────┐
│ DynamoDB          │
│ (TodoListテーブル)│
└───────────────────┘
```

1.  **API Gateway v2 (HTTP API):**
    *   terraform-aws-modules/terraform-aws-apigateway-v2 モジュールを使用
    *   クライアントからのHTTPリクエストを受け付けます。
    *   リクエストの内容に応じて、Step Functionsのステートマシンをトリガーします。
    *   `/create` (POST): 新しいToDoアイテムを作成します。
    *   `/get` (GET): 既存のToDoアイテムを取得します。
    *   CORS設定済み

2.  **Step Functions:**
    *   terraform-aws-modules/step-functions モジュールを使用
    *   リクエストされた操作（`create`または`get`）に基づいて、DynamoDBとのやり取りを制御します。
    *   ステートマシンは`stepfunctions/statemachine.json`で定義されています。

3.  **DynamoDB:**
    *   ToDoアイテムを格納する`TodoList`テーブルです。

### 主な変更点（terraform-aws-modules使用）

- **API Gateway v1 → v2 (HTTP API)**: より高いパフォーマンスと低いコスト
- **モジュール化**: 再利用可能で保守しやすい構成
- **設定の簡素化**: ルートと統合の設定が一箇所にまとまっている
- **変数化**: 設定値が変数化され、カスタマイズが容易
- **タグ統一**: 全リソースに共通のタグが適用される

### Lambdaレスアーキテクチャの利点

*   **管理の簡素化:** Lambda関数を管理・デプロイする必要がなくなります。
*   **コスト削減:** Lambdaの実行料金がかからず、API Gateway、Step Functions、DynamoDBの利用料金のみで済みます。
*   **パフォーマンス:** 特定のユースケースでは、Lambdaのコールドスタートによる遅延を回避できます。

## セットアップとデプロイ

### 前提条件

*   [AWS CLI](https://aws.amazon.com/cli/) がインストールおよび設定済みであること。
*   [Terraform](https://www.terraform.io/downloads.html) がインストール済みであること。

### デプロイ手順

1.  **リポジトリをクローンします。**
    ```bash
    git clone https://github.com/your-username/aws-apigateway-no-lambda.git
    cd aws-apigateway-no-lambda
    ```

2.  **Terraformを初期化します。**
    これにより、プロバイダプラグインがダウンロードされます。
    ```bash
    terraform init
    ```

3.  **（オプション）デプロイ計画を確認します。**
    どのようなリソースが作成されるかを確認できます。
    ```bash
    terraform plan
    ```

4.  **インフラストラクチャをデプロイします。**
    ```bash
    terraform apply
    ```
    `yes`と入力して承認すると、AWSリソースの作成が開始されます。

## APIエンドポイント

デプロイが完了すると、API GatewayのエンドポイントURLがTerraformの出力として表示されます。

### 1. アイテムの作成

*   **メソッド:** `POST`
*   **URL:** `(デプロイされたURL)/v1/create`
*   **リクエストボディ:**
    ```json
    {
      "id": "todo-001",
      "task": "最初のタスク"
    }
    ```
*   **レスポンス例:**
    ```json
    // Step Functionsの実行ARNと開始時刻
    {
      "executionArn": "arn:aws:states:...",
      "startDate": ...
    }
    ```

### 2. アイテムの取得

*   **メソッド:** `GET`
*   **URL:** `(デプロイされたURL)/v1/get?id=todo-001`
*   **クエリパラメータ:**
    *   `id`: 取得したいアイテムのID
*   **レスポンス例:**
    ```json
    // Step Functionsの実行ARNと開始時刻
    {
      "executionArn": "arn:aws:states:...",
      "startDate": ...
    }
    ```
    *注意: Step Functionsの実行結果としてDynamoDBから取得したアイテムが返されます。実際のレスポンスはAWSコンソールで確認してください。*

## 作成されるリソース

このTerraform設定によって、以下の主要なAWSリソースが作成されます。

*   `aws_api_gateway_rest_api`: `TodoAPI`
*   `aws_api_gateway_resource`: `/create`, `/get`
*   `aws_api_gateway_method`: `POST`, `GET`
*   `aws_api_gateway_integration`: API GatewayとStep Functionsの連携
*   `aws_api_gateway_deployment`: APIのデプロイ
*   `aws_api_gateway_stage`: `v1`ステージ
*   `aws_sfn_state_machine`: `todo-state-machine`
*   `aws_dynamodb_table`: `TodoList`
*   `aws_iam_role`: API GatewayとStep Functionsが必要とするIAMロール

## クリーンアップ

作成したすべてのリソースを削除するには、以下のコマンドを実行します。

```bash
terraform destroy
```
`yes`と入力して承認すると、リソースの削除が開始されます。
