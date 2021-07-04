output "private_subnet_ids" {
  description = "Private subnets"
  value       = aws_subnet.private.*.id
}

output "s3_prefix_list" {
  description = ""
  value       = aws_vpc_endpoint.s3.prefix_list_id
}
