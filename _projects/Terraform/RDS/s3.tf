# -------- Terraform Backend --------
terraform {
  backend "s3" {
    bucket         = "my-kops-state-bucket-david"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# -------- S3 Bucket --------
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-kops-state-bucket-david"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}