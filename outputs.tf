output "subnet_id" {
  description = "ID of the created public subnets"
  value = coalescelist(
    aws_subnet.private.*.id,
    aws_subnet.public.*.id
  )
}

output "ngw_id" {
  value       = join("", aws_nat_gateway.public_ngw.*.id)
  description = "NAT Gateway ID"
}