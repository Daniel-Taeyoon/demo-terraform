provider "aws" {
  region = "ap-northeast-2"
}
module "tf-daniel-network" {
  source = "./1-network"
}