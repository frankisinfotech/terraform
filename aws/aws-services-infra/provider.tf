terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "xxxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxx"
}
