module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-00c39f71452c08778"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id, aws_security_group.EC2.id]
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Terraform   = "true"
  }
}