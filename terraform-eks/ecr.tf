resource "aws_ecr_repository" "react_frontend" {
  name = "react-frontend"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

output "react_frontend_ecr_url" {
  description = "The URL of the ECR repository for the React frontend"
  value       = aws_ecr_repository.react_frontend.repository_url
}
