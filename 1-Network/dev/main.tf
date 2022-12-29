provider "aws" {
  region = "ap-northeast-2"
  profile = "DEV-DEX"
}

#########################################
# Network Infra(ex. VPC, Subnet, Internet Gateway ...)
#########################################
module "aws_network" {
  source = "../../modules/network"

  cidr_block = "10.12.0.0/16"

  public_subnet_cidrs = ["10.12.0.0/24", "10.12.8.0/24"]

  ecs_subnet_cidrs = ["10.12.24.0/24", "10.12.32.0/24"]

  data_subnet_cidrs = ["10.12.36.0/24", "10.12.40.0/24"]

}