terraform {
  backend "s3" {
   bucket = "terraform-rajshah"
   key = "global/s3/terraform.tfstate"
   region = "ap-south-1"
   encrypt = true

}

}
