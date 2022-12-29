provider "aws" {
  region = "ap-northeast-2"
  profile = "STG-DEX"
}

#########################################
# Network Infra(ex. VPC, Subnet, Internet Gateway ...)
#########################################
module "aws_network" {
  source = "../../modules/network"

  cidr_block = "10.22.0.0/16"

  public_subnet_cidrs = ["10.22.0.0/24", "10.22.8.0/24"]

  ecs_subnet_cidrs = ["10.22.24.0/24", "10.22.32.0/24"]

  data_subnet_cidrs = ["10.22.36.0/24", "10.22.40.0/24"]

}