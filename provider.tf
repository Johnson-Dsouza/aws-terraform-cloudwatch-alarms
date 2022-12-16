terraform {
  required_version = ">= 0.15"

  backend "s3" {
    bucket = "test-terraform-state"
    key    = "terraform.tfstate"
    region = var.aws_region

    dynamodb_table = "test-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
