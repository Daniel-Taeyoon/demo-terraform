# element(list, index)
# depends_on : 의존성을 말해준다. 의존성있는 리소스 생성 후 해당 리소스를 실행한다.(ex. VPC 생성 후 Subnet 생성)
# count :
# - 인스턴스 or 리소스 생성할 것인지 지정 할 수 있다.
# - 인스턴스 or 리소스가 거의 동일한 경우 count 사용이 적절하다.

# TODO : Modify Subnet Name ${count.index}
resource "aws_subnet" "sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs) # length(var.public_subnet_cidrs) 길이만큼 리소스를 생성하라는 의미이다.
  vpc_id = aws_vpc.vpc-tf-daniel.id
  cidr_block = element(var.public_subnet_cidrs, count.index )
  tags = {
    Name = "sbn-tf-daniel-public-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.vpc-tf-daniel
  ]
}

resource "aws_subnet" "sbn-tf-daniel-ecs" {
  count = length(var.ecs_subnet_cidrs)
  vpc_id = aws_vpc.vpc-tf-daniel.id
  cidr_block = element(var.ecs_subnet_cidrs, count.index )
  tags = {
    Name = "sbn-tf-daniel-ecs-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.vpc-tf-daniel
  ]
}