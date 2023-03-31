output "subnet_id" {
  description = "ID of the created subnet"
  value = coalescelist(
    aws_subnet.private.*.id,
    aws_subnet.public.*.id
  )[0]
  
}

output "ngw_id" {
  value       = join("", aws_nat_gateway.public_ngw.*.id)
  description = "NAT Gateway ID"
}