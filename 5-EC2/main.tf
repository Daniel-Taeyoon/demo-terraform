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

variable "vpc_id_demo_devops" {
  default = "default_vpc_id"
}

variable "subnet_id_demo_devops" {
  default = "default_subnet_id"
}

# AWS Profile. 즉, AWS CLI에 셋팅되어 있는 Profile 환경 값을 설정한다.
# Profile에 따라 인프라가 적용되는 환경이 다르니 terraform plan을 통해 확인 후 적용(apply)하자
provider "aws" {
  region = var.demo_devops_region[terraform.workspace]
  profile = "${var.aws_profile[terraform.workspace]}-demo-devops"
}


resource "aws_security_group" "example" {
  vpc_id = var.vpc_id_demo_devops

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scg-ec2-demo-devops"
  }
}

## Create EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0e38c97339cddf4bd"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id_demo_devops
  security_groups = [aws_security_group.example.id]

  depends_on = [aws_security_group.example]

  tags = {
    Name = "ec2-demo-devops"
  }
}