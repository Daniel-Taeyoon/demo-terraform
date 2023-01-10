variable "dex_region" {
  type = map(string)
  default = {
    "develop" : "ap-northeast-2"
    "stage" : "ap-northeast-2"
    "main" : "ap-southeast-1"
  }
}

variable "aws_profile" {
  type = map(string)
  default = {
    "develop" : "DEV"
    "stage" : "STG"
    "main" : "PRD"
  }
}

provider "aws" {
  region = var.dex_region[terraform.workspace]
  profile = "${var.aws_profile[terraform.workspace]}-DEX"
}

resource "aws_ecr_repository" "this" {
  name = "tf-daniel-ecr"
  force_delete = false
  image_tag_mutability = "MUTABLE"
}