resource "aws_vpc" "vpc_tf" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags                 = { Name = "${var.vpc_name}" }
}


resource "aws_subnet" "sn_one" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = cidrsubnet("${var.vpc_cidr_block}", 4, 1)
  availability_zone = "us-east-1a"

   tags = {
    Name = join("-", ["SN", var.vpc_name, "1"])
  }

}

resource "aws_subnet" "sn_two" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = cidrsubnet("${var.vpc_cidr_block}", 4, 2)
  availability_zone = "us-east-1b"

  tags = {
    Name = join("-", ["SN", var.vpc_name, "2"])
  }

}

resource "aws_subnet" "sn_three" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = cidrsubnet("${var.vpc_cidr_block}", 4, 3)
  availability_zone = "us-east-1c"

   tags = {
    Name = join("-", ["SN", var.vpc_name, "3"])
  }

}

resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_tf.id
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }

}

resource "aws_route_table_association" "vpc_sn_public_rt_assoc_one" {
  subnet_id      = aws_subnet.sn_one.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "vpc_sn_public_rt_assoc_two" {
  subnet_id      = aws_subnet.sn_two.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "vpc_sn_public_rt_assoc_three" {
  subnet_id      = aws_subnet.sn_three.id
  route_table_id = aws_route_table.rt_public.id
}
