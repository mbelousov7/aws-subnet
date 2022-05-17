resource "aws_subnet" "public" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = var.availability_zone

  cidr_block = var.cidr_block

  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(
    var.tags,
    { Name = "${var.tags.prefix}-${var.tags.env}-${var.tags.component}-subnet-public" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id
  tags = merge(
    var.tags,
    { Name = "${var.tags.prefix}-${var.tags.env}-${var.tags.component}-routetable-public" }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}



