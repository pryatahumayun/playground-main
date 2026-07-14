variable "service_name" {
  type        = string
  description = "Name for the ECS cluster, service, ALB, and all related resources."
}

variable "region" {
  type        = string
  description = "AWS region the service is deployed into. Used for CloudWatch log config."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to deploy into."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where ECS tasks run."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs used when the ALB is internet-facing."
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate attached to the HTTPS ALB listener."
}

variable "container_port" {
  type        = number
  default     = 8080
  description = "Port the container listens on."
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy (e.g. 'staging', 'latest', or a git SHA)."
}

variable "task_cpu" {
  type        = number
  default     = 512
  description = "CPU units for the Fargate task (256, 512, 1024, 2048, 4096)."
}

variable "task_memory" {
  type        = number
  default     = 1024
  description = "Memory in MiB for the Fargate task."
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Initial desired number of running tasks."
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of tasks for auto-scaling."
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 5
  description = "Maximum number of tasks for auto-scaling."
}

variable "health_check_path" {
  type        = string
  default     = "/healthz"
  description = "HTTP path the ALB target group uses for health checks."
}

variable "health_check_command" {
  type        = list(string)
  default     = []
  description = "Optional ECS container-level health check command, e.g. [\"CMD-SHELL\", \"curl -f http://localhost:8080/healthz\"]."
}

variable "log_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain CloudWatch logs."
}

variable "lb_internal" {
  type        = bool
  default     = false
  description = "Set true to make the ALB internal (not internet-facing)."
}

variable "enable_lb_deletion_protection" {
  type        = bool
  default     = false
  description = "Prevent accidental deletion of the ALB. Recommended true in production."
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks allowed to reach the ALB on ports 80 and 443."
}

variable "environment" {
  type        = map(string)
  default     = {}
  description = "Plaintext environment variables injected into the container."
}

variable "secrets" {
  type        = map(string)
  default     = {}
  description = "Map of ENV_VAR_NAME => Secrets Manager ARN. The execution role is automatically granted GetSecretValue."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to every resource created by this module."
}
