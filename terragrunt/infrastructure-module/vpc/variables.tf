variable "private_subnets" {
  description = "CIDR ranges for private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR ranges for public subnets."
  type        = list(string)
}

variable "env" {
  description = "Environment name."
  type        = string
}

variable "azs" {
  description = "Availability zones for subnets."
  type        = list(string)
}



