resource "aws_ecr_repository" "devflow" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project     = "DevFlow"
    ManagedBy   = "Terraform"
    Environment = "Development"
  }
}

resource "aws_ecr_lifecycle_policy" "devflow" {
  repository = aws_ecr_repository.devflow.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Retain the most recent SHA-tagged images"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["sha-*"]
          countType      = "imageCountMoreThan"
          countNumber    = var.image_retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
