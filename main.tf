provider "aws"{
  region = "ap-south-1"
}
resource "aws_instance" "example"{
  ami = "ami-47205e28"
  instance_type = "t2.micro"
  key_name = "rajshah-mumbai" 
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              service httpd start
              chkconfig httpd on
              cd /var/www/html
              echo "Hello World   now please work" > index.html
              EOF


  vpc_security_group_ids = ["${aws_security_group.instance.id}"]


  tags{
    Name = "Terraform-example-1"
}
}
#variable "server_port"{
#  description="The port the server will use for HTTP requests"
#}

resource "aws_security_group" "instance"{

name = "terraform-example-instance"

  ingress{
    from_port=80    #"${var.server_port}"
    to_port=80   #"${var.server_port}"
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]

}

  ingress{
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}
  egress{
    from_port =0
    to_port =0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

output "public_ip"{

value = "${aws_instance.example.public_ip}"

}
