locals {
  public_count = var.type == "public" ? 1 : 0

  ngw_name = "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-ngw-${var.labels.env}"
}

resource "aws_subnet" "public" {
  count                   = local.public_count
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

resource "aws_route_table" "public" {
  count  = local.public_count
  vpc_id = data.aws_vpc.default.id
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.subnet_name },
    { Type = var.type },
  )
}

resource "aws_route" "public" {
  count                  = local.public_count
  route_table_id         = aws_route_table.public.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id == "" ? null : var.igw_id
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.*.id[count.index]
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "public_ngw_eip" {
  count = local.public_count
  vpc   = true
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.ngw_name },
  )
}

# NAT
resource "aws_nat_gateway" "public_ngw" {
  count         = local.public_count
  allocation_id = join("", aws_eip.public_ngw_eip.*.id)
  subnet_id     = aws_subnet.public.*.id[0]

  tags = merge(
    var.labels,
    var.tags,
    { Name = local.ngw_name },

  )
}



