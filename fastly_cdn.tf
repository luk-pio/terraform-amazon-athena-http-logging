locals {
  public_path    = "public"
  index_document = "index.html"
  subdomain      = "www.${var.domain}"
}

resource "fastly_service_vcl" "test_domain" {
  force_destroy = true
  name          = "athena_demo"

  domain {
    name = local.subdomain
  }

  backend {
    address        = aws_s3_bucket_website_configuration.website.website_endpoint
    name           = "AWS S3 hosting"
    port           = 80
    ssl_check_cert = false
    use_ssl        = false
  }

  logging_s3 {
    name        = aws_s3_bucket.log_bucket.id
    bucket_name = aws_s3_bucket.log_bucket.id
    domain      = "s3.${aws_s3_bucket.log_bucket.region}.amazonaws.com"
    s3_iam_role = aws_iam_role.fastly_s3_logging_assume_role.arn
    redundancy  = "standard"
    # Stream logs to S3 every 5 minutes
    period = 300
    # gzipped data improves athena performance
    gzip_level = 9
    # This gives automatic Athena partitions for domain, year, month, day
    path             = "fastly/logs/domain=${var.domain}/year=%Y/month=%m/day=%d/"
    timestamp_format = "%Y-%m-%dT%H:%M:%S.000"
    format_version   = "2"
    message_type     = "blank"
    format           = file("${path.module}/templates/athena_log_format.tpl")
  }

}
