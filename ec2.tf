resource "aws_instance" "first_ec2" {
  depends_on             = [aws_security_group.sg_for_ec2]
  ami                    = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_for_ec2.id]
  tags = {
    Name        = "webserver_1"
    Environment = var.env
  }
}

resource "aws_instance" "second_ec2" {
  depends_on             = [aws_security_group.sg_for_ec2]
  ami                    = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_for_ec2.id]
  tags = {
    Name        = "webserver_2"
    Environment = var.env
  }
}

resource "aws_instance" "new_ec2" {
  depends_on             = [aws_security_group.sg_for_ec2]
  ami                    = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_for_ec2.id]
  tags = {
    Name        = "webserver_3"
    Environment = var.env
  }
}