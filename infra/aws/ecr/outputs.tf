output "repository_name" {
  description = "ECR repository name."
  value       = aws_ecr_repository.devflow.name
}

output "repository_url" {
  description = "ECR repository URL for Docker image publishing."
  value       = aws_ecr_repository.devflow.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN."
  value       = aws_ecr_repository.devflow.arn
}
