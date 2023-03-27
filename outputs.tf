output "EC2_public_ip" {
  value = module.ec2_instance.*.public_ip
}

output "RDS_Endpoint" {
  value = module.db.db_instance_endpoint
}