provider "aws" {
  profile = "AWS CLI에 설정한 Profile 작성"
  region = "ap-northeast-2"
}

resource "aws_instance" "devops_ec2_daniel" {
  ami           = "ami-00248a35359dc2100"
  instance_type = "t2.micro"
}