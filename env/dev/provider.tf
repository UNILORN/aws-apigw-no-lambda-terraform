terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "unilorn-toybox-terraform-state.unilorn.net"
    key    = "aws-apigateway-no-lambda/dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}