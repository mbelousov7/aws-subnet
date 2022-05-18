# Get object aws_vpc by vpc_id
data "aws_vpc" "default" {
  id = var.vpc_id
}

locals {
  subnet_name = var.subnet_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-subnet-${var.type}-${var.labels.env}"
  ) : var.subnet_name
}