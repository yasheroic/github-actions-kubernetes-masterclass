variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
  default     = "t3.large"
}