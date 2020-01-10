resource "aws_codebuild_project" "main" {
  name          = "${var.project_name}-codebuild"
  description   = "${var.domain_name} CodeBuild Project"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "BUCKETNAME"
      value = var.domain_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

