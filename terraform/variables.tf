variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  type = map(string)
  default = {
    default = "t3.large"
    dev     = "t3.small"
    stg     = "t3.medium"
    prd     = "t3.large"
  }
}