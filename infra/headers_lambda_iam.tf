resource "aws_iam_role" "headers_lambda" {
  name               = "headers_lambda_edge"
  assume_role_policy = data.aws_iam_policy_document.headers_assume_role_policy.json
}

data "aws_iam_policy_document" "headers_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "headers_lambda_permission" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "headers_lambda_policy" {
  name        = "headers-lambda-edge"
  description = "Policy used with Cloudfront Edge lambda"
  policy      = data.aws_iam_policy_document.headers_lambda_permission.json
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda-policy-attachment"
  policy_arn = aws_iam_policy.headers_lambda_policy.arn
  roles      = [aws_iam_role.headers_lambda.id]
}
