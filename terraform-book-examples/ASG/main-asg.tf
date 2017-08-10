provider "aws"{
 region = "ap-south-1"
}

resource "aws_launch_configuration" "example" {

 image_id = "ami-47205e28"
 instance_type = "t2.micro"
 security_group = ["${aws_security_group.instance.id}"]
 
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
