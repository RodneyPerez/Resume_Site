provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

data "archive_file" "headers_lambda" {
  type = "zip"
  source {
    content  = file("index.js")
    filename = "index.js"
  }
  output_path = "index.zip"
}

resource "aws_lambda_function" "headers_lambda" {
  provider         = aws.east
  filename         = "${path.module}/index.zip"
  function_name    = "headers_lambda_edge"
  role             = aws_iam_role.headers_lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.headers_lambda.output_base64sha256
  runtime          = "nodejs10.x"
  publish          = true
  tags             = var.tags
  depends_on = [
    "aws_iam_policy_attachment.lambda_policy_attachment"
  ]
}


