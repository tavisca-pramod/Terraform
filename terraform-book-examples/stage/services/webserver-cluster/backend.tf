terraform {
  backend "s3" {
   bucket = "terraform-rajshah"
   key = "stage/services/webserver-cluster/terraform.tfstate"
   region = "ap-south-1"
   encrypt = true

}

}
