terraform {
  backend "s3" {
    bucket         = "wk10-gn-terraform"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-log"
  }
}