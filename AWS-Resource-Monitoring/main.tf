# terraform {
#   required_version = ">= 1.0.0"
# #   required_providers {
# #     aws = {
# #       source  = "hashicorp/aws"
# #       version = "~> 5.0"
# #     }
# #   }
# }

provider "aws" {
  region = "us-east-1" # Update to your preferred AWS region
}


# ---  LAMBDA EXECUTION ROLE ---
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "resource_monitor_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Attach standard AWS-managed policy for CloudWatch logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy for reading AWS resources and writing reports to S3
data "aws_iam_policy_document" "lambda_permissions_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "ec2:Describe*",
      "s3:ListAllMyBuckets",
      "iam:ListUsers",
      "lambda:ListFunctions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  name   = "resource_monitor_permissions"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_permissions_doc.json
}


# --- PACKAGE PYTHON SCRIPT INTO A ZIP ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}


# ---  AWS LAMBDA FUNCTION ---
resource "aws_lambda_function" "resource_monitor" { 
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "aws_resource_monitor"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.14"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 120
}

# --- 5. EVENTBRIDGE SCHEDULER ROLE ---
data "aws_iam_policy_document" "scheduler_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduler_role" {
  name               = "resource_monitor_scheduler_role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json
}

# Policy allowing EventBridge Scheduler to trigger your Lambda
data "aws_iam_policy_document" "scheduler_lambda_invoke_doc" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.resource_monitor.arn]
  }
}

resource "aws_iam_role_policy" "scheduler_lambda_invoke" {
  name   = "scheduler_lambda_invoke_policy"
  role   = aws_iam_role.scheduler_role.id
  policy = data.aws_iam_policy_document.scheduler_lambda_invoke_doc.json
}


# --- 6. EVENTBRIDGE SCHEDULER (Triggers every 10 minutes) ---
resource "aws_scheduler_schedule" "daily_trigger" {
  name                         = "daily-resource-monitor-schedule"
  group_name                   = "default"
  schedule_expression          = "cron(0/10 * * * ? *)" # Invokes Lambda function every 10 minutes
  schedule_expression_timezone = "UTC"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.resource_monitor.arn
    role_arn = aws_iam_role.scheduler_role.arn
  }
}