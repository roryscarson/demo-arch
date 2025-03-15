
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16" //10.0.0.0 - 10.0.255.255
  instance_tenancy = "default"

  tags = {
    Name  = "demo-arch-vpc"
    owner = "roryscarson"
  }
}

//public subnets range 10.0.0.0 - 10.0.0.255
resource "aws_subnet" "public1-euw1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/28"

  tags = {
    Name  = "demo-arch-subnet-public1-eu-west-1a"
    owner = "roryscarson"
  }

}
resource "aws_subnet" "public2-euw1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.16/28"

  tags = {
    Name  = "demo-arch-subnet-public2-eu-west-1b"
    owner = "roryscarson"
  }
}
resource "aws_subnet" "public3-euw1c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/28"

  tags = {
    Name  = "demo-arch-subnet-public3-eu-west-1c"
    owner = "roryscarson"
  }
}

//private subnet range 10.0.1.0 - 10.0.1.255
resource "aws_subnet" "private1-euw1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name  = "demo-arch-subnet-private1-eu-west-1a"
    owner = "roryscarson"
  }

}

