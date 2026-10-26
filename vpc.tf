module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "blast-radius-zero-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b"]
  public_subnets   = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnets  = ["10.0.20.0/24", "10.0.21.0/24"]
  database_subnets = ["10.0.30.0/24", "10.0.31.0/24"]

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  enable_nat_gateway = true
  single_nat_gateway = true
}
