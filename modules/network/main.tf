# resource "given_type" "local name" -> ex) resource "aws_instance" "ec2-demo"
# "local name"은 코드 상에서 사용하는 것일뿐 AWS 리소스에 반영되지 않는다.
# meta data : depends_on, count, for_each, provider, lifecycle
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-dev-dex"
  }
}

# element(list, index)
# depends_on : 의존성을 말해준다. 의존성있는 리소스 생성 후 해당 리소스를 실행한다.(ex. VPC 생성 후 Subnet 생성)
# count :
# - 인스턴스 or 리소스 생성할 것인지 지정 할 수 있다.
# - 인스턴스 or 리소스가 거의 동일한 경우 count 사용이 적절하다.
# TODO : Modify Subnet Name ${count.index}
resource "aws_subnet" "sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs) # length(var.public_subnet_cidrs) 길이만큼 리소스를 생성하라는 의미이다.
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.public_subnet_cidrs, count.index )
  availability_zone = element(var.azs, count.index )
  tags = {
    Name = "sbn-dev-an2-dex-public-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_subnet" "sbn-tf-daniel-ecs" {
  count = length(var.ecs_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.ecs_subnet_cidrs, count.index )
  availability_zone = element(var.azs, count.index )
  tags = {
    Name = "sbn-dev-an2-dex-ecs-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_subnet" "sbn-tf-daniel-data" {
  count = length(var.data_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.data_subnet_cidrs, count.index )
  availability_zone = element(var.azs, count.index )
  tags = {
#    Name = format("sbn-dev-an2-dex-data-${regex("ap-northeast-2\\[a-z]", var.azs)}")
    Name = "sbn-dev-an2-dex-data-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_internet_gateway" "igw-tf-daniel" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igw-dev-dex"
  }
}

#resource "aws_default_route_table" "rt-tf-daniel" {
#  default_route_table_id = aws_vpc.vpc-tf-daniel.default_route_table_id
#}

# "vpc-tf-daniel" Route Table 수정.
# Internet Gateway 추가
resource "aws_route_table" "rt-vpc" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-dev-an2-dex-vpc"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

resource "aws_route_table" "rt-subnet-public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-dev-an2-dex-public"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

# 생성한 Route Table을 Public Subnet에 적용
# TODO : Private, ECS Subnet을 위한 Route Table 필요
# - (선제조건으로 NAT 생성 후 해당 NAT를 기반으로 Route Table 매핑이 필요하다)
resource "aws_route_table_association" "rt-sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.sbn-tf-daniel-public[*].id, count.index)
  route_table_id = aws_route_table.rt-subnet-public.id
}