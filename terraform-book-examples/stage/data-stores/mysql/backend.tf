terraform {
 backend "s3"{
  bucket = "terraform-rajshah"
  key = "stage/data-stores/mysql/terraform.tfstate"
  region = "ap-south-1"
  encrypt = true

}

}
