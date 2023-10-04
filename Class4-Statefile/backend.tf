terraform {
  backend "s3" {
    bucket = "kaizen-adilet"
    key    = "kaizen/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "lock-state"
  }
}