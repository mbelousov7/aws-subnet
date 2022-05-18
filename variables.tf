variable "labels" {
  type = object({
    prefix    = string
    stack     = string
    component = string
    env       = string
  })
  description = "Minimum required map of labels(tags) for creating aws resources"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "type" {
  type        = string
  description = "Type of subnets (`private` or `public`)"
  default     = "private"
}

variable "subnet_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the subnet.
      By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default     = "null"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID the public route table will point to"
  default     = ""
}

variable "ngw_id" {
  type        = string
  description = "NAT Gateway ID which will be used as a default route in private route tables"
  default     = ""
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone where subnets will be created"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Instances launched into a public subnet should be assigned a public IP address"
}
