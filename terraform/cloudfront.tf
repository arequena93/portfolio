resource "aws_cloudfront_origin_access_control" "portfolio_oac" {
  name        = "OAC for Portfolio Website"
  description = "OAC for antonirs portfolio website"
  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "portfolio_distribution" {
  origin {
    domain_name = aws_s3_bucket.personal_portfolio_bucket.bucket_regional_domain_name
    origin_id   = "S3-antonirs-portfolio"
    origin_access_control_id = aws_cloudfront_origin_access_control.portfolio_oac.id
  }

  enabled = true
  comment = "Distribution for the antonirs.com static website"
  aliases = ["antonirs.com"]
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]

    target_origin_id = "S3-antonirs-portfolio"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.personal_web_portfolio_cert.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }
}

