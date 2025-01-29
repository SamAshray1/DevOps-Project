terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "http://localhost:8200"
  token   = ""
}

data "vault_generic_secret" "aws_creds" {
  path = "aws-creds/credentials"
}


provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_generic_secret.aws_creds.data["AWS_ACCESS_KEY_ID"]
  secret_key = data.vault_generic_secret.aws_creds.data["AWS_SECRET_ACCESS_KEY"]
}

data "vault_generic_secret" "ssh_key" {
  path = "ssh/private-key"
}

resource "aws_key_pair" "ansible" {
  key_name = "ansible-key"
  public_key = file(data.vault_generic_secret.ssh_key.data["private_key"])
}
