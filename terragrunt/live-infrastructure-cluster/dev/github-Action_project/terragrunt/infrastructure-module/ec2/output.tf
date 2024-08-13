output "public_ips" {
  value = module.ec2-instance.public_ip
  description = "Public IP address of the EC2 instance"
}

