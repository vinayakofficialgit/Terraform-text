

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "vinayak-eks-${random_string.suffix.result}"
  vpcname  = "vinayakvpc=${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 7
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name                 = local.vpcname
  cidr                 = var.vpc_cidr
  azs               = data.aws_availability_zones.available.names      
  private_subnets      = ["10.0.1.0/24", "10.0.10.0/24"]
  public_subnets       = ["10.0.40.0/24", "10.0.50.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
