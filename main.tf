provider "aws" {
  region = "ap-northeast-2"
  profile = "default"
}

#module "tf-daniel-network" {
#  source = "./1-network"
#}

module "tf-dniael-iam" {
  source = "./2-IAM"
}