provider "aws" {
  region = "ap-northeast-2"
}

module "iam_user" {
  source = "../../modules/iam-user"
  name          = "terraform-user"
  force_destroy = true
}