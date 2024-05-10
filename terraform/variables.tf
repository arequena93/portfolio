variable "region" {
  description = "The AWS region where the resources will be created"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the portfolilo"
  type        = string
}

variable "bucket_name" {
  description = "The S3 bucket name to store the portfolio (static files)"
  type        = string
}