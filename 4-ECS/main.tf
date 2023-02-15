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

variable "serviceName" {
  type = string
  description = "Infra Service Name"
}

provider "aws" {
  region = var.dex_region[terraform.workspace]
  profile = "${var.aws_profile[terraform.workspace]}-${var.serviceName}"
}

resource "aws_ecs_cluster" "this" {
  name = "tf-daniel-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "tf_demo_devops_log_group"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family = "tf-demo-devops-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072
  runtime_platform {
    operating_system_family = "LINUX/X86_64"
  }
  task_role_arn = "arn:aws:iam::677001239926:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::677001239926:role/ecsTaskExecutionRole"

  container_definitions = <<EOF
  [
    {
        "name": "tf-demo-devops",
        "image": "677001239926.dkr.ecr.ap-northeast-2.amazonaws.com/tf-demo-devops:latest",
        "cpu": 0,
        "portMappings": [
            {
                "containerPort": 8080,
                "hostPort": 8080,
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "entryPoint": [],
        "command": [],
        "environment": [],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
                "awslogs-region": "${var.dex_region[terraform.workspace]}",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
  ]
  EOF
}

resource "aws_security_group" "tf-demo-devops-sg" {
  vpc_id = "vpc-0c44b74eb20c95b74"
  name = "scg-tf-demo-devops"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "tf-demo-devops-alb" {
  name = "tf-demo-devops-alb"
  security_groups = [aws_security_group.tf-demo-devops-sg.id]
  subnets = ["subnet-09b8f2f9491842db6", "subnet-0dfcf2ca4e720e287"]
  tags = {
    Terraform_TEST = "True"
  }
}

resource "aws_alb_listener" "tf-demo-devops-http" {
  load_balancer_arn = aws_alb.tf-demo-devops-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tf-demo-devops-tg.arn
  }
}


resource "aws_alb_target_group" "tf-demo-devops-tg" {
  name     = "tf-demo-devops-tg"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "vpc-0c44b74eb20c95b74" // Replace with your VPC ID

  health_check {
    path     = "/testApi"
    protocol = "HTTP"
  }

  tags = {
    Terraform_TEST = "True"
  }
}

resource "aws_alb_target_group_attachment" "tf-demo-devops-alb-attach" {
  target_group_arn = aws_alb_target_group.tf-demo-devops-tg.arn
#  port             = 80
  target_id = aws_ecs_service.this.id
}

resource "aws_ecs_service" "this" {
  name            = "tf-demo-devops-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["sg-01df6fa235527b451"]
    subnets = ["subnet-062f03f021c917c90", "subnet-07d0fb24f04e24e8d"]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tf-demo-devops-tg.id
    container_name = "tf-demo-devops"
    container_port = 8080
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}


