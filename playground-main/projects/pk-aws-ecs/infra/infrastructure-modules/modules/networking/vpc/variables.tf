variable "vpc_name" {
  description = "Name tag applied to the VPC and all child resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones used to create one public and one private subnet per AZ."
  type        = list(string)
}

variable "tags" {
  description = "Additional tags merged onto every resource."
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment name automatically passed by Terragrunt."
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region automatically passed by Terragrunt."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS account ID automatically passed by Terragrunt."
  type        = string
  default     = ""
}
