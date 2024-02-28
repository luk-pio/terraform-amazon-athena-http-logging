resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-demo-athena-log-bucket"
}

resource "aws_iam_role_policy_attachment" "fastly_s3_logging_put_object_attachment" {
  role       = aws_iam_role.fastly_s3_logging_assume_role.name
  policy_arn = aws_iam_policy.s3_put_object_policy.arn
}

resource "aws_iam_role" "fastly_s3_logging_assume_role" {
  name = "fastly_s3_logging_assume_role"
  assume_role_policy = data.aws_iam_policy_document.fastly_s3_logging_assume_role.json
}

data "aws_iam_policy_document" "fastly_s3_logging_assume_role" {
  statement {
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [var.fastly_customer_id]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.fastly_aws_principal]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "s3_put_object_policy" {
  name        = "fastly_s3_logging_put_object_policy"
  path        = "/"
  description = "IAM policy for allowing PutObject on S3 bucket"

  policy = data.aws_iam_policy_document.s3_put_object_policy.json
}

data "aws_iam_policy_document" "s3_put_object_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log_bucket.arn}/*"]
  }
}
