provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "kaizen-key"
  public_key = file("~/.ssh/id_rsa.pub")
  tags = {
    Team = "DevOps"
    Env = "Dev"
    Company = "Kaizen"
  }
}