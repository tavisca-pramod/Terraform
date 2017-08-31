data "template_file" "user_data" {
 template = "${file("${path.module}/user-data.sh")}"

 vars {
  db_address = "${data.terraform_remote_state.db.address}"
  db_port = "${data.terraform_remote_state.db.port}"
}
}
resource "aws_launch_configuration" "example" {

 image_id = "ami-47205e28"
 instance_type = "${var.instance_type}"
 security_groups= ["${aws_security_group.instance.id}"]
 key_name = "rajshah-mumbai"
 user_data = "${data.template_file.user_data.rendered}"  

 lifecycle {
  create_before_destroy = true
}

}
resource "aws_security_group" "instance" {

 name = "${var.cluster_name}-instance"
 lifecycle {
 create_before_destroy = true
}
}

resource "aws_security_group_rule" "allow_http_inbound_instance" {
 type = "ingress"
 security_group_id = "${aws_security_group.instance.id}"
 from_port = "80"
 to_port = "80"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound_instance" {
 type = "ingress"
 security_group_id = "${aws_security_group.instance.id}"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
}
 resource "aws_security_group_rule" "allow_all_outbound_instance"{
 type = "egress"
 security_group_id = "${aws_security_group.instance.id}"
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
}

 data "aws_availability_zones" "all"{} 
 data "terraform_remote_state" "db"{
  backend = "s3"
  config {
   bucket = "${var.db_remote_state_bucket}"
   key = "${var.db_remote_state_key}"
   region = "ap-south-1"
}
}

 resource "aws_autoscaling_group" "example"{
 launch_configuration = "${aws_launch_configuration.example.id}"
 availability_zones = ["${data.aws_availability_zones.all.names}"]

 load_balancers = ["${aws_elb.example.name}"]
 health_check_type = "ELB"

 min_size = "${var.min_size}"
 max_size = "${var.max_size}"
 tag {
  key = "Name"
  value = "${var.cluster_name}"
  propagate_at_launch = true
}

}

 resource "aws_elb" "example"{
  name = "${var.cluster_name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb.id}"]
  listener {
   lb_port = 80
   lb_protocol = "http"
   instance_port = "${var.server_port}"
   instance_protocol = "http"

}

 health_check{
  healthy_threshold = 2
  unhealthy_threshold = 2
  timeout = 3
  interval = 30
  target = "HTTP:${var.server_port}/"
}
}
 resource "aws_security_group" "elb" {
 name = "${var.cluster_name}-elb"
}

 resource " aws_security_group_rule" "allow_http_inbound_elb"{
  type = "ingress"
  security_group_id = "${aws_security_group.elb.id}" 
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

 resource "aws_security_group_rule" "allow_all_outbound_elb"{
  type = "egress"
  security_group_id = "${aws_security_group.elb.id}" 
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


