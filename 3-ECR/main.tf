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

# tags를 활용해 리소스를 구분한다.
# ECS - Task Definition, Service 연결 시 아래 tags와 data를 활용해 리소스를 연결시킬 수 있다.
resource "aws_ecr_repository" "this" {
  name = "tf-demo-devops"
  force_delete = false
  image_tag_mutability = "MUTABLE"
  tags = {
    Terraform_TEST = "True"
  }
}