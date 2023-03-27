resource "aws_security_group" "allow_tls" {
  name        = "allow_htto"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "EC2" {
    name = "allow ssh"
    description = "ssh to ec2"
    vpc_id = aws_vpc.main_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    }
  
    egress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "sg_RDS" {
    name = "RDS security Group"
    description = "RDS SG"
    vpc_id = aws_vpc.main_vpc.id

    ingress {
        description = "Allow db port"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    }

    egress {
        description = "Allow db port"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    }
    
    tags = {
      "Name" = "Allow db port"
    }
}