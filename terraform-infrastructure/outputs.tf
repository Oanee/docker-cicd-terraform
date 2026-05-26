output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.frontend_cdn.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend_cdn.id
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.backend.name
}
