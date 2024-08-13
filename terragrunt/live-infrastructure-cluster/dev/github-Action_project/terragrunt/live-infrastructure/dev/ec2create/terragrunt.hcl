terraform {
  source = "../../../infrastructure-module/ec2/"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc/"
}

inputs = {
  ami_id            = "ami-04a81a99f5ec58529"   
  instance_type     = "t2.medium"
  key_name          = "newkypair"            
  subnet_id         = dependency.vpc.outputs.pub_subnet[0]  
  security_group_id = dependency.vpc.outputs.id_sgrp  
}





