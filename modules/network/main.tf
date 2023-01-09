# resource "given_type" "local name" -> ex) resource "aws_instance" "ec2-demo"
# "local name"은 코드 상에서 사용하는 것일뿐 AWS 리소스에 반영되지 않는다.
# meta data : depends_on, count, for_each, provider, lifecycle
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block[terraform.workspace]
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.environment_lower[terraform.workspace]}-dex"
  }
}

# element(list, index)
# depends_on : 의존성을 말해준다. 의존성있는 리소스 생성 후 해당 리소스를 실행한다.(ex. VPC 생성 후 Subnet 생성)
# count :
# - 인스턴스 or 리소스 생성할 것인지 지정 할 수 있다.
# - 인스턴스 or 리소스가 거의 동일한 경우 count 사용이 적절하다.
resource "aws_subnet" "sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs[terraform.workspace]) # length(var.public_subnet_cidrs) 길이만큼 리소스를 생성하라는 의미이다.
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.public_subnet_cidrs[terraform.workspace], count.index )
  availability_zone = element(var.azs[terraform.workspace], count.index )
  tags = {
    Name = "sbn-${var.environment_lower[terraform.workspace]}-an2-dex-public-${
      replace(element(var.azs[terraform.workspace], count.index), var.dex_region[terraform.workspace], "")
    }"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_subnet" "sbn-tf-daniel-ecs" {
  count = length(var.ecs_subnet_cidrs[terraform.workspace])
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.ecs_subnet_cidrs[terraform.workspace], count.index )
  availability_zone = element(var.azs[terraform.workspace], count.index )
  tags = {
    Name = "sbn-${var.environment_lower[terraform.workspace]}-an2-dex-ecs-${
      replace(element(var.azs[terraform.workspace], count.index), var.dex_region[terraform.workspace], "")
    }"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_subnet" "sbn-tf-daniel-data" {
  count = length(var.data_subnet_cidrs[terraform.workspace])
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.data_subnet_cidrs[terraform.workspace], count.index )
  availability_zone = element(var.azs[terraform.workspace], count.index )
  tags = {
    Name = "sbn-${var.environment_lower[terraform.workspace]}-an2-dex-data-${
      replace(element(var.azs[terraform.workspace], count.index), var.dex_region[terraform.workspace], "")
    }"
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_internet_gateway" "igw-tf-daniel" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igw-${var.environment_lower[terraform.workspace]}-dex"
  }
}

# "create_before_destroy"는 해당 리소스만 삭제한다.
# 기존에 생성된 aws_eip가 존재하는 경우 해당 리소스는 삭제하지 않는다.
resource "aws_eip" "nat_eip" {
  vpc   = true

  tags = {
    Name = "eip-${var.environment_lower[terraform.workspace]}-an2-dex-nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat-tf-daniel" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.sbn-tf-daniel-public[0].id

  tags = {
    Name = "nat-${var.environment_lower[terraform.workspace]}-an2-dex"
  }

  depends_on = [aws_internet_gateway.igw-tf-daniel]
}

# "vpc-tf-daniel" Route Table 수정.
# Internet Gateway 추가
resource "aws_route_table" "rt-vpc" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-${var.environment_lower[terraform.workspace]}-an2-dex-vpc"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

#Route Table 생성
resource "aws_route_table" "rt-subnet-public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-${var.environment_lower[terraform.workspace]}-an2-dex-public"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

resource "aws_route_table" "rt-subnet-ecs" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-tf-daniel.id
  }
  tags = {
    Name = "rt-${var.environment_lower[terraform.workspace]}-an2-dex-ecs"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

resource "aws_route_table" "rt-subnet-data" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-tf-daniel.id
  }
  tags = {
    Name = "rt-${var.environment_lower[terraform.workspace]}-an2-dex-data"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

# Route Table과 VPC 연결. Main Route Table 생성
resource "aws_main_route_table_association" "rt-vpc-tf-daniel" {
  vpc_id = aws_vpc.this.id
  route_table_id = aws_route_table.rt-vpc.id
}

# Route Table과 (public, ecs, data) Subnet 연결
resource "aws_route_table_association" "rt-sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs[terraform.workspace])
  subnet_id = element(aws_subnet.sbn-tf-daniel-public[*].id, count.index)
  route_table_id = aws_route_table.rt-subnet-public.id
}

resource "aws_route_table_association" "rt-sbn-tf-daniel-ecs" {
  count = length(var.ecs_subnet_cidrs[terraform.workspace])
  subnet_id = element(aws_subnet.sbn-tf-daniel-ecs[*].id, count.index)
  route_table_id = aws_route_table.rt-subnet-ecs.id
}

resource "aws_route_table_association" "rt-sbn-tf-daniel-data" {
  count = length(var.data_subnet_cidrs[terraform.workspace])
  subnet_id = element(aws_subnet.sbn-tf-daniel-data[*].id, count.index)
  route_table_id = aws_route_table.rt-subnet-data.id
}