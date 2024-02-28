variable "domain" {
  type = string
}

variable "fastly_aws_principal" {
  type = string
  default = "717331877981"
}

variable "fastly_customer_id" {
  type = string
  sensitive = true
}

variable "fastly_api_key" {
  type = string
  sensitive = true
}
