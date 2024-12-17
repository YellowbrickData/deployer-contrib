terraform {
  required_version = "~> 1.9"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
