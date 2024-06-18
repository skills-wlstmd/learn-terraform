resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "wlstmd_default_vpc_${var.env}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  count = var.env == "prd" ? 0 : 1
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "wlstmd_public_subnet_1_${var.env}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.100.0/24"
  availability_zone = local.az_a  

  tags = {
    Name = "wlstmd_private_subnet_1_${var.env}"
  }
}

# resource "aws_nat_gateway" "private_nat" {
#   connectivity_type = "private"
#   subnet_id = aws_subnet.private_subnet_1.id

#   tags = {
#     Name = "wlstmd_nat_${var.env}"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.default.id

#   tags = {
#     Name = "wlstmd_igw_${var.env}"
#   }
# }