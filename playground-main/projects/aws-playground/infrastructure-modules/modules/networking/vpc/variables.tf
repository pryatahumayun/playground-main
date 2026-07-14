variable "vpc_name" {
  type        = string
  description = "Name tag applied to the VPC and all child resources."
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR block for the VPC, e.g. 10.0.0.0/16."
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to create subnets in. One public + one private subnet is created per AZ."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags merged onto every resource."
}
