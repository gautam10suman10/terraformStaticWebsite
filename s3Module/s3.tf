resource "aws_s3_bucket" "s3Bucket" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
  tags = {
    Name = var.bucket_tag_name
  }
}
resource "aws_s3_bucket_public_access_block" "s3Public" {
  bucket                  = aws_s3_bucket.s3Bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${var.folderLocation} s3://${aws_s3_bucket.s3Bucket.id}"
  }
}



data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3Bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.s3Bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}