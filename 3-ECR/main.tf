variable "demo_devops_region" {
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
  region = var.demo_devops_region[terraform.workspace]
  profile = "${var.aws_profile[terraform.workspace]}-demo-devops"
}

# tags를 활용해 리소스를 구분한다.
# ECS - Task Definition, Service 연결 시 아래 tags와 data를 활용해 리소스를 연결시킬 수 있다.
resource "aws_ecr_repository" "this" {
  name = "tf-daniel-ecr"
  force_delete = false
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = "demo-devops"
    Terraform_TEST = "True"
  }
}