# Athena HTTP Log analysis Demo

This is a terraform project to demonstrate how to use Amazon Athena to analyze HTTP logs.

It uses terraform to provision:

- A domain on Amazon Route53 DNS
- A new service on Fastly CDN, corresponding to the domain
- A new CNAME record for your domain which points to Fastly CDN
- An S3 static web hosting which serves a simple `index.html` file
- An S3 bucket for storing HTTP logs

The paired blog post shows you how to analyze the logs using Amazon Athena.

## Prerequisites

You will need a few things before you get started:

- terraform 1.7+
- An AWS account with access to:
  - IAM
  - Route 53
  - S3
- A registered domain you own
- A Fastly account and:
  - Your Fastly api key
  - Your Fastly customer id

## Running

There are 3 variables you will need to provide during execution:

- `domain`: The domain you want to use
- `fastly_customer_id`: Your Fastly customer Id
- `fastly_api_key`: Your Fastly API key

You can provide these variables using a `.tfvars` file or on the command line.

Then simply use the terraform plan/apply workflow.
