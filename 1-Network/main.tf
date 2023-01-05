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

#########################################
# Network Infra(ex. VPC, Subnet, Internet Gateway ...)
#########################################
module "aws_network" {
  source = "../modules/network"
#  cidr_block = "10.12.0.0/16"
#
#  public_subnet_cidrs = ["10.12.0.0/24", "10.12.8.0/24"]
#
#  ecs_subnet_cidrs = ["10.12.24.0/24", "10.12.32.0/24"]
#
#  data_subnet_cidrs = ["10.12.38.0/24", "10.12.40.0/24"]
#
#  azs = ["ap-northeast-2a", "ap-northeast-2c"]
}