terraform {
  backend "s3" {
    bucket = "rodney-terraform-state-files"
    key    = "resume_site/tfstate"
    region = "us-east-2"
  }
}

