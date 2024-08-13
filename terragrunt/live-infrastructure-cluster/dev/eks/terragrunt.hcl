terraform {
  source = "../../../infrastructure-module/eks-cluster"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  eks_version = "1.30"
  env         = include.env.locals.env
  eks_name    = "demovincluster"
  subnet_ids  = dependency.vpc.outputs.pub_subnet

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t2.medium"]
      scaling_config = {
        desired_size = 2
        max_size     = 10
        min_size     = 0
      }
    }
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}