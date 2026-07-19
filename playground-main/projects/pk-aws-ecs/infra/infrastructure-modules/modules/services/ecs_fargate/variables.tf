variable "service_name" {
  description = "Name for the ECS cluster, ECS service, ALB, and related resources."
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository created for the service."
  type        = string
}

variable "container_name" {
  description = "Container name used in the ECS task definition."
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region used by CloudWatch log configuration."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to deploy into."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where ECS tasks run."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used when the ALB is internet-facing."
  type        = list(string)
}

variable "container_port" {
  description = "Port the container listens on."
  type        = number
  default     = 8080
}

variable "image_tag" {
  description = "Docker image tag to deploy."
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the Fargate task."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory in MiB for the Fargate task."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Initial desired task count."
  type        = number
  default     = 1
}

variable "autoscaling_min_capacity" {
  description = "Minimum task count for auto-scaling."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum task count for auto-scaling."
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "HTTP path used by the ALB target group health check."
  type        = string
  default     = "/health"
}

variable "health_check_command" {
  description = "Optional ECS container health check command."
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs."
  type        = number
  default     = 30
}

variable "lb_internal" {
  description = "Whether the ALB is internal-only."
  type        = bool
  default     = false
}

variable "enable_lb_deletion_protection" {
  description = "Whether ALB deletion protection is enabled."
  type        = bool
  default     = false
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "environment" {
  description = "Plaintext environment variables injected into the container."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Map of environment variable name to Secrets Manager ARN."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment name automatically passed by Terragrunt."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS account ID automatically passed by Terragrunt."
  type        = string
  default     = ""
}
