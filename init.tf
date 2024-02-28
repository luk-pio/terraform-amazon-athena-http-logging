terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
    fastly = {
      source  = "fastly/fastly"
      version = "5.6.0"
    }
  }

  required_version = ">= 1.7.0"
}

provider "fastly" {
  api_key = var.fastly_api_key
}

provider "aws" {
  region = "eu-west-1"
  profile = "athena_logs_demo"
}