# Terraform Guide 문서
terraform init 실행한 디렉토리 구조를 기본으로 변수 선언 및 리소스 값들이 설정된다.

## AWS Infra Architecture
![image](https://user-images.githubusercontent.com/30804139/206130106-67952e36-363e-4834-9b06-32798f21b8fe.png)

## Terraform Language

- count
```
variable "subnet_ids" {
    type = list(string)
}

resource "aws_instance" "server" {
    # Create one instance for each subnet
    count = length(var.subnet_ids)
    ami           = "ami-a1b2c3d4"
    instance_type = "t2.micro"
    subnet_id     = var.subnet_ids[count.index]

    tags = {
        Name = "Server ${count.index}"
    }
}
```
This was fragile, because the resource instances were still identified by their index instead of the string values in the list. If an element was removed from the middle of the list, every instance after that element would see its subnet_id value change, resulting in more remote object changes than intended. Using for_each gives the same flexibility without the extra churn.

=> 인스턴스 or 리소스에 구분 값을 count.index로 하는 것은 지양한다.

## Code Structure Example
- "Large-size infrastructure with Terraform" 기준으로 코드 작성.  
- 디렉토리 구조는 아래와 같다.
  - 인프라별(ex. 1-Network, 2-IAM ...) 분리
    - "1-Network", "2-IAM" .. 등 인프라 명칭에 따라 기능을 분리한다.
    - ~~환경별(dev, stg, prd) 디렉토리를 분리한 이유는 AWS CLI Profile이 다르고, 입력해야 할 변수가 다르기 때문이다.~~
      => terraform workspace로 분리. develop(DEV), stage(STG), main(PRD) 환경에 따라 매개변수를 다르게 주입한다. 
  - modules
    - 환경은 다르더라도 전체적인 인프라 로직은 거의 동일하다.
    - 모듈로 분리함으로써 중복 코드를 최소화 한다.
```
├── 1-Network
│   ├─ main.tf
│
├── 2-IAM
│   ├─ dev
│   ├─ stg
│   ├─ prd
│
├── modules
│   ├─ iam-user
│   ├─ network
│
```
참고 : https://www.terraform-best-practices.com/examples/terraform/large-size-infrastructure-with-terraform

# Terraform Workspace
workspace를 활용해 환경별로 분리된 상태와 인프라 소스코드를 관리 할 수 있다.  
주요 기능으로는
- 환경별로 다른 configuration file을 관리 할 수 있다.
- workspace는 환경별로 분리 및 독립 될 수 있다.

_참고_
- Terraform Configuration Language : https://developer.hashicorp.com/terraform/language/resources
- How to Build AWS VPC using Terraform : https://spacelift.io/blog/terraform-aws-vpc
- [Ubuntu] AWS EC2 AMI List : https://cloud-images.ubuntu.com/locator/ec2/
- Github terraform-aws-iam : https://github.com/terraform-aws-modules/terraform-aws-iam/tree/v5.9.2
- Terraform - Workspaces Overview : https://medium.com/devops-mojo/terraform-workspaces-overview-what-is-terraform-workspace-introduction-getting-started-519848392724