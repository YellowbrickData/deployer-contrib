output "subnet_primary_cidr" {
  value = aws_subnet.primary.cidr_block
}

output "subnet_public_cidr" {
  value = aws_subnet.public.cidr_block
}

output "subnet_secondary_cidr" {
  value = aws_subnet.secondary.cidr_block
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "primary_zone" {
  value = var.primary_zone
}

output "secondary_zone" {
  value = var.secondary_zone
}

