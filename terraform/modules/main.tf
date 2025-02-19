terraform {
  backend "s3" {
    bucket         = "terraform-learning-samuel-devops"
    key            = "modules/web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  environment_name = terraform.workspace
}

module "web_server" {
  source = "./modules"
  environment_name = local.environment_name
}
