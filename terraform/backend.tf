terraform {
  backend "s3" {
    bucket = "terraform-state-roryscarson"
    key    = "demo-arch"
    region = "eu-west-1"
  }
}
