# Dev Frontend Bucket (Private)
resource "aws_s3_bucket" "dev_frontend_bucket" {
  bucket = "dev-frontend-bucket-oluwa"
  tags = {
    Name        = "dev-frontend-bucket-oluwa"
    Environment = "Dev"
  }
}

# Prod Frontend Bucket (Private)
resource "aws_s3_bucket" "prod_frontend_bucket" {
  bucket = "prod-frontend-bucket-oluwa"
  tags = {
    Name        = "prod-frontend-bucket-oluwa"
    Environment = "Prod"
  }
}

# Configure website hosting for Dev Frontend Bucket
resource "aws_s3_bucket_website_configuration" "dev_website" {
  bucket = aws_s3_bucket.dev_frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Configure website hosting for Prod Frontend Bucket
resource "aws_s3_bucket_website_configuration" "prod_website" {
  bucket = aws_s3_bucket.prod_frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# We will add the following later when we are ready to upload files
# Set Public Access to Objects Only (not the entire bucket)
# resource "aws_s3_object" "dev_frontend_index" {
#   bucket = aws_s3_bucket.dev_frontend_bucket.bucket
#   key    = "index.html"
#   source = "./build/index.html"  # Path to your local index.html file for dev
#   acl    = "public-read"
# }

# resource "aws_s3_object" "prod_frontend_index" {
#   bucket = aws_s3_bucket.prod_frontend_bucket.bucket
#   key    = "index.html"
#   source = "./build/index.html"  # Path to your local index.html file for prod
#   acl    = "public-read"
# }
