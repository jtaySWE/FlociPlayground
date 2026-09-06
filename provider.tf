terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  
  # Necessary bypasses for local cloud emulators
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  # Redirect individual AWS services to Floci's local edge port
  endpoints {
    apigateway     = var.localEndpoint
    dynamodb       = var.localEndpoint
    ec2            = var.localEndpoint
    iam            = var.localEndpoint
    lambda         = var.localEndpoint
    rds            = var.localEndpoint
    s3             = var.localEndpoint
    secretsmanager = var.localEndpoint
    sns            = var.localEndpoint
    sqs            = var.localEndpoint
    ssm            = var.localEndpoint
    sts            = var.localEndpoint
    mq             = var.localEndpoint
  }
}
