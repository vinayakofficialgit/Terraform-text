variable "env" {
  description = "Variable used to define environment"
  type        = string
  default     = "demo"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  

}


variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true 
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true 
}


