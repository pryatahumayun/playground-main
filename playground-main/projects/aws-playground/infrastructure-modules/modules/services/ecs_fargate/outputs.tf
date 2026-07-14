output "cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "Name of the ECS cluster."
}

output "cluster_arn" {
  value       = aws_ecs_cluster.this.arn
  description = "ARN of the ECS cluster."
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "Name of the ECS service."
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the Application Load Balancer."
}

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ARN of the Application Load Balancer."
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "ECR repository URL. Push images here before deploying."
}

output "task_role_arn" {
  value       = aws_iam_role.task.arn
  description = "ARN of the ECS task IAM role (the identity the container runs as)."
}

output "execution_role_arn" {
  value       = aws_iam_role.execution.arn
  description = "ARN of the ECS execution IAM role."
}

output "cloudwatch_log_group" {
  value       = aws_cloudwatch_log_group.this.name
  description = "CloudWatch log group name for container logs."
}
