terraform {
  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
  
  backend "remote" {
  # The name of your Terraform Cloud organization.
  organization = "sdn-l3"

  # The name of the Terraform Cloud workspace to store Terraform state files in.
  workspaces {
    name = "aws-tf-cloud-1"
    }
  }
}

  

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
 


data "aws_ami" "amazon_linux" {
	most_recent = true
	owners = ["amazon"]
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}

module "vpc_blue" {
  source = "./templates/vpc"
  vpc_cidr_block = "100.64.0.0/16"
}

module "sg_1" {
  source = "./templates/sg"
  vpc_id = module.vpc_blue.vpc_tf_id
}

module "high_avail_1" {
  source = "./templates/high-avail"

  vpc_id     = module.vpc_blue.vpc_tf_id
  ssh_key_name = "nathan-m-kp"
  image_id = data.aws_ami.amazon_linux.id
  subnet_ids = module.vpc_blue.vpc_subnets
  sg_id = module.sg_1.vpc_tf_sg_id

}

