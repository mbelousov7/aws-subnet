locals {
  private_count = var.type == "private" ? 1 : 0
  ngw_count     = var.type == "private" && var.ngw_id != "" ? 1 : 0
}

resource "aws_subnet" "private" {
  count                   = local.private_count
  vpc_id                  = data.aws_vpc.default.id
  availability_zone       = var.availability_zone
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.subnet_name },
    { Type = var.type },
  )
}

resource "aws_route_table" "private" {
  count  = local.private_count
  vpc_id = data.aws_vpc.default.id
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.subnet_name },
    { Type = var.type },
  )
}

resource "aws_route" "private" {
  count                  = local.ngw_count
  route_table_id         = aws_route_table.private.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.ngw_id
}

resource "aws_route_table_association" "private" {
  count          = local.private_count
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}



