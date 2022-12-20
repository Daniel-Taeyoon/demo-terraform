resource "aws_internet_gateway" "igw-tf-daniel" {
  vpc_id = aws_vpc.vpc-tf-daniel.id
  tags = {
    Name = "igw-tf-daniel"
  }
}