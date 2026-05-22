terraform {
  required_version = ">= 1.15.3"

  backend "s3" {
    bucket       = "terraform-bucket-18052026"
    key          = "infra/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.46.0"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.12.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "mongodbatlas" {
  public_key  = var.mongo_public_key
  private_key = var.mongo_private_key
}
