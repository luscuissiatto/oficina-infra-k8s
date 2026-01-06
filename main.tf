# oficina-infra-k8s/main.tf

data "aws_availability_zones" "available" {}

# 1. Cria uma VPC Exclusiva para o Cluster (Melhor prática)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "oficina-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Economiza dinheiro ($) nos créditos
  enable_vpn_gateway = false

  tags = {
    "kubernetes.io/cluster/oficina-cluster" = "shared"
  }
}

# 2. Cria o Cluster EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "oficina-cluster"
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.medium"] # Ideal para rodar Java + Monitoramento
      capacity_type  = "ON_DEMAND"
    }
  }
}