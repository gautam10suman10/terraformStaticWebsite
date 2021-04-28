resource "aws_route53_record" "terrformRoute" {
  zone_id = var.zoneId
  name    = "terraform.fuseprojects.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.terraformTest.domain_name
    zone_id                = aws_cloudfront_distribution.terraformTest.hosted_zone_id
    evaluate_target_health = true
  }
}