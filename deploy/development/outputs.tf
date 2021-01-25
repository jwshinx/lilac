output "bastion_host" {
  value = aws_instance.bastion.public_dns
}

output "postgres_db_host" {
  value = aws_db_instance.lilac_postgres.address
}

output "colleges_lb_address" {
  value = aws_lb.colleges.dns_name
}
