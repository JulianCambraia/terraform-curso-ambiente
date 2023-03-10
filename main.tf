terraform {
  required_version = ">=1.1.0"
  required_providers {
    aws = ">= 4.0"
  }

  backend "s3" {
    bucket = "jfac-curso-terraform-state"
    key    = "terraform-curso-ambiente.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "us-east-1"
}

module "ec2" {
  source    = "git@github.com:JulianCambraia/terraform-aws-ec2.git"
  int_type  = "t2.micro"
  int_name  = "WEB"
  user_data = file("./files/userdata.sh")
  ami       = "ami-0b5eea76982371e91"
  subnet    = module.vpc.public_subnets
}

module "vpc" {
  source    = "git@github.com:JulianCambraia/terraform-aws-vpc.git"
  vpc_name  = "dev"
  vpc_cidr  = "172.32.0.0/16"
  nat_count = 2
}


