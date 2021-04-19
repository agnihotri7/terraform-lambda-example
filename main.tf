# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A PYTHON FUNCTION TO AWS LAMBDA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --------------------------------------------------------
# AWS PROVIDER SETUP
# --------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "test-tff" # local.s3_bucket_name  #terraform-state-prod
    key    = "network/terraform.tfstate" # local.s3_bucket_key   #network/terraform.tfstate
    region = "eu-west-1" # local.aws_region
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region # "${var.aws_region}"

  default_tags {
    tags = {
      Environment = var.env
      Name        = var.env
    }
  }
}

# --------------------------------------------------------
# CREATE AN IAM LAMBDA EXECUTION ROLE WHICH WILL BE ATTACHED TO THE FUNCTION
# --------------------------------------------------------

resource "aws_iam_role_policy" "test-tff-policy" {

  name = "test-tff-policy_${var.env}"
  role = aws_iam_role.test-tff-role.id
  policy = file("lambda-policy.json")

}

resource "aws_iam_role" "test-tff-role" {

  name = "test-tff-role_${var.env}"
  assume_role_policy = file("lambda-assume-role-policy.json")

}

# --------------------------------------------------------
# AWS LAMBDA EXPECTS A DEPLOYMENT PACKAGE
# A deployment package is a ZIP archive that contains your function code and dependencies.
# --------------------------------------------------------
locals {
    lambda_zip_location =  "output/main.py.zip"
}

data "archive_file" "lambda_data" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = local.lambda_zip_location
}

# --------------------------------------------------------
# DEPLOY THE LAMBDA FUNCTION
# --------------------------------------------------------
resource "aws_lambda_function" "test_tff" {
  filename        = local.lambda_zip_location
  function_name   = "test_tff_${var.env}"
  role            = aws_iam_role.test-tff-role.arn
  handler         = "handler.lambda_handler"
  runtime         = "python3.7"

  source_code_hash = filebase64sha256(local.lambda_zip_location)

  environment {
    variables = {
        foo = var.foo
    }
  }
}

# --------------------------------------------------------
# OUTPUT
# --------------------------------------------------------
output "lambda_arn" {
  value = aws_iam_role.test-tff-role.arn
}

