# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "AKIA6B7OJRORZNX67ZBE"
  secret_key = "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"
  region = var.region_name
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_default_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_lambda_function" "udacity_lambda" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  handler       = "greet_lambda.lambda_handler"
  source_code_hash = filebase64sha256("greet_lambda.zip")
  runtime = "python3.8"
  role = aws_iam_role.lambda_exec_role.arn

  environment {
      variables = {
        greeting = "greeting"
      }
    }
}