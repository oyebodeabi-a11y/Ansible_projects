terraform {
  backend "s3" {
    bucket = "aws-ansible-training"
    region = "eu-west-2"
    key    = "ansible/terraform.tfstate"
  }
}