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

### 참고
- Terraform Configuration Language : https://developer.hashicorp.com/terraform/language/resources
- How to Build AWS VPC using Terraform : https://spacelift.io/blog/terraform-aws-vpc
- [Ubuntu] AWS EC2 AMI List : https://cloud-images.ubuntu.com/locator/ec2/
- Github terraform-aws-iam : https://github.com/terraform-aws-modules/terraform-aws-iam/tree/v5.9.2