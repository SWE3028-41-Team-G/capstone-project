terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
  }

  backend "s3" {
    bucket         = "skkudm-tfstate-storage"
    key            = "terraform/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "skkudm-tfstate-lock"
  }
}

module "skkudm" {
  source = "./skkudm"

  region            = var.region
  postgres_password = var.postgres_password
  postgres_username = var.postgres_username
  jwt_secret        = var.jwt_secret
}

module "cdn" {
  source = "./cdn"
}
