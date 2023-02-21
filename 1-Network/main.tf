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

# AWS Profile. 즉, AWS CLI에 셋팅되어 있는 Profile 환경 값을 설정한다.
# Profile에 따라 인프라가 적용되는 환경이 다르니 terraform plan을 통해 확인 후 적용(apply)하자
provider "aws" {
  region = var.demo_devops_region[terraform.workspace]
  profile = "${var.aws_profile[terraform.workspace]}-demo-devops"
}

#########################################
# Network Infra(ex. VPC, Subnet, Internet Gateway ...)
#########################################
module "aws_network" {
  source = "../modules/network"
}