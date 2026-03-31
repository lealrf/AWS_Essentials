# ==========================================
# 1. COMPUTE: Application Server (EC2)
# ==========================================

# Dynamically fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values =["al2023-ami-2023.*-x86_64"]
  }
}

# Create a Security Group for the EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "healthsync_app_sg"
  description = "Allow HTTP inbound traffic for the PoC app"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =["0.0.0.0/0"]
  }
}

# Launch the EC2 Instance (Free Tier Eligible)
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free Tier eligible

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "HealthSync-App-Server"
  }
}

# ==========================================
# 2. STORAGE: Secure Medical Records (S3)
# ==========================================

# Create the S3 Bucket
resource "aws_s3_bucket" "medical_records" {
  bucket = "healthsync-records-rl-2026" 
}

# HIPAA Compliance: Enable Server-Side Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_storage" {
  bucket = aws_s3_bucket.medical_records.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# HIPAA Compliance: Block all public access to the medical records
resource "aws_s3_bucket_public_access_block" "secure_access" {
  bucket = aws_s3_bucket.medical_records.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}