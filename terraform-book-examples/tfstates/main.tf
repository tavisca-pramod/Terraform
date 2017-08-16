provider "aws"{
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform-rajshah" {
 bucket = "terraform-rajshah"

 versioning {
  enabled = true
}
 lifecycle {
  prevent_destroy = true
}
}

output "s3_bucket_arn"{
 value = "aws_s3_bucket.terraform-rajshah.arn"

}
