resource "aws_instance" "first_ec2" {
  depends_on             = [ aws_security_group.second_sg ]
  ami                    = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.second_sg.id ]
  tags = {
    Name        = "webserver_2"
    Environment = var.env 
  }
}

resource "aws_instance" "second_ec2" {
  depends_on             = [ aws_security_group.second_sg ]
  ami                    = "ami-0be2609ba883822ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.second_sg.id ]
  tags = {
    Name        = "webserver_2"
    Environment = var.env 
  }
}
