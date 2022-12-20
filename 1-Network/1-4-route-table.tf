#resource "aws_default_route_table" "rt-tf-daniel" {
#  default_route_table_id = aws_vpc.vpc-tf-daniel.default_route_table_id
#}

# "vpc-tf-daniel" Route Table 수정.
# Internet Gateway 추가
resource "aws_route_table" "rt-vpc" {
  vpc_id = aws_vpc.vpc-tf-daniel.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-vpc-tf-daniel"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

resource "aws_route_table" "rt-subnet-public" {
  vpc_id = aws_vpc.vpc-tf-daniel.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf-daniel.id
  }
  tags = {
    Name = "rt-sbn-tf-daniel-public"
  }
  depends_on = [
    aws_internet_gateway.igw-tf-daniel
  ]
}

# 생성한 Route Table("rt-vpc-tf-daniel")을 public 서브넷에 그대로 적용
resource "aws_route_table_association" "rt-sbn-tf-daniel-public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.sbn-tf-daniel-public[*].id, count.index)
  route_table_id = aws_route_table.rt-subnet-public.id
}