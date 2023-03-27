module "db" {
  source  = "terraform-aws-modules/rds/aws"
  identifier = "mysqldb"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  db_name  = "demodb"
  username = "user"
  port     = "3306"
  iam_database_authentication_enabled = false
  vpc_security_group_ids = [ aws_security_group.sg_RDS.id ]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_monitoring_role = false
  create_db_subnet_group = true
  subnet_ids = aws_subnet.private_subnet.*.id 
  family = "mysql5.7"
  major_engine_version = "5.7"
  deletion_protection = false

  tags = {
    name = "duck"
  }
}