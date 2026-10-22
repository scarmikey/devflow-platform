variable "aws_region" {
  description = "AWS region for DevFlow ECR."
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Amazon ECR repository name for DevFlow."
  type        = string
  default     = "devflow-api"
}

variable "image_retention_count" {
  description = "Number of recent SHA-tagged images to retain."
  type        = number
  default     = 10

  validation {
    condition     = var.image_retention_count >= 1
    error_message = "At least one SHA-tagged image must be retained."
  }
}
