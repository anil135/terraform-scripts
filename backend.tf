terraform {
  backend "s3" {
    bucket         = "anil-interview-demo" # change this to your bucket name
    key            = "anil/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}