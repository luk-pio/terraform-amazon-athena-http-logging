resource "aws_s3_bucket" "website" {
  bucket = local.subdomain
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = local.index_document
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.website.id
  key          = local.index_document
  source       = "${local.public_path}/${local.index_document}"
  content_type = "text/html"

  etag = filemd5("${local.public_path}/${local.index_document}")
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json

}

data "fastly_ip_ranges" "fastly" {}
data "aws_iam_policy_document" "website" {
  statement {
    sid       = "AddPerm"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = data.fastly_ip_ranges.fastly.cidr_blocks
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}
