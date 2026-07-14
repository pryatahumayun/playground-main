output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the VPC."
}

output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "CIDR block of the VPC."
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "List of public subnet IDs (one per AZ)."
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.private : s.id]
  description = "List of private subnet IDs (one per AZ)."
}
