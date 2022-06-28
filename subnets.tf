resource "aws_subnet" "subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}a"
  cidr_block              = "100.10.0.0/20"
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "subnet-1b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}b"
  cidr_block              = "100.10.16.0/20"
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.aws_region}c"
  cidr_block              = "100.10.32.0/20"
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.default_tag
  }
}