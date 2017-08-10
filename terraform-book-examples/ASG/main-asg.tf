provider "aws"{
 region = "ap-south-1"
}

resource "aws_launch_configuration" "example" {

 image_id = "ami-47205e28"
 instance_type = "t2.micro"
 security_group = ["${aws_security_group.instance.id}"]
 key_name = "rajshah-mumbai"
 user_data = <<-EOF
		#!/bin/bash
		yum update -y
		yum install httpd -y
		service httpd start
		chkconfig httpd on
		echo "hello world" > /var/www/html/index.html
		EOF

 lifecycle {
  create_before_destroy = true
}

}

variable "server_port"{
 description = "Enter the port for server HTTP requests"
}

resource "aws_security_group" "instance" {

 name = "terraform-ASG-instance"

 ingress {
 from_port = "${var.server_port}"
 to_port = "${var.server_port}"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}
 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
}

 lifecycle {
 create_before_destroy = true
}
}

 data "aws_availability_zones" "all"{} 


 resource "aws_autoscaling_group" "example"{
 launch_configuration = "${aws_launch_configuration.example.id}"
 availability_zones = ["${data.aws_avalibility_zones.all.names}"]
 min_size = 2
 max_size = 4
 tag {
  key = "Name"
  value = "terraform_ASG_example"
  propagate_at_launch = true
}

}


