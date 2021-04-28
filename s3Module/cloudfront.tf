resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "terraformOAI"
}


resource "aws_cloudfront_distribution" "terraformTest" {

  origin {
    domain_name = aws_s3_bucket.s3Bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  dynamic custom_error_response{
    for_each = toset(var.error)
    content{


      error_caching_min_ttl = 3000
      error_code            = custom_error_response.value
      response_code         = 200
      response_page_path    = "/right-sidebar.html"
  

    }
  }
  
  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"
  restrictions {
    geo_restriction {
      restriction_type = "none"

    }
  }
  aliases = ["terraform.fuseprojects.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  tags = {
    Name = "Terraform Cloudfront"
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificateArn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}