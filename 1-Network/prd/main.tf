provider "aws" {
  region = "ap-northeast-2"
  profile = "PRD-DEX"
}

#########################################
# Network Infra(ex. VPC, Subnet, Internet Gateway ...)
#########################################
module "aws_network" {
  source = "../../modules/network"

  cidr_block = "10.32.0.0/16"

  public_subnet_cidrs = ["10.32.0.0/24", "10.32.8.0/24"]

  ecs_subnet_cidrs = ["10.32.24.0/24", "10.32.32.0/24"]

  data_subnet_cidrs = ["10.32.36.0/24", "10.32.40.0/24"]

}