provider "aws" {
 region = "ap-south-1"
}

module "webserver-cluster"{
 source = "/root/terraform-book-examples/modules/services/webserver-cluster/"
 
 cluster_name = "webservers-stage"
 db_remote_state_bucket = "terraform-rajshah"
 db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

 instance_type = "t2.micro"
 min_size = 2
 max_size = 4
 server_port = 80
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
 scheduled_action_name = "scale_out_during_business_hours"
 min_size = 2
 max_size = 4
 desired_capacity = 3
 recurrence = "0 9 * * *"
 
 autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night"{
 scheduled_action_name = "scale_in_at_night"
 min_size = 2
 max_size = 4
 desired_capacity = 2
 recurrence = "0 17 * * *"

 autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}


