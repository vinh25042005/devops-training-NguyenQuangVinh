terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tfstate-vinh-1782202788"
    key            = "phase1/week2/day3.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}
