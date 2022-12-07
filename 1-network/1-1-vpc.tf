# resource "given_type" "local name" -> ex) resource "aws_instance" "ec2-demo"
# "local name"은 코드 상에서 사용하는 것일뿐 AWS 리소스에 반영되지 않는다.
# meta data : depends_on, count, for_each, provider, lifecycle
resource "aws_vpc" "vpc-tf-daniel" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-tf-daniel"
  }
}