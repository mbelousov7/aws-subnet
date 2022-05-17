output "public_subnet_id" {
  description = "ID of the created public subnets"
  value       = aws_subnet.public.id
}