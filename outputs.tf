output "app_server_public_ip" {
  description = "The public IP address of the HealthSync App Server"
  value       = aws_instance.app_server.public_ip
}

output "secure_s3_bucket_name" {
  description = "The globally unique name of the HIPAA-compliant S3 bucket"
  value       = aws_s3_bucket.medical_records.id
}