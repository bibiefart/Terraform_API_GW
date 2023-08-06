# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-1"
}

variable "s3_bucket_prefix" {
  description = "S3 bucket prefix"
  type = string
  default = "bibi-s3-v4"

}

variable "dynamodb_table" {
  description = "name of the ddb table"
  type = string
  default = "Movies"

}

variable "lambda_name" {
  description = "name of the lambda function"
  type = string
  default = "pattern-movies-post"

}

variable "lambda_get_name" {
  description = "name of the lambda function"
  type = string
  default = "pattern-movies-get"

}

variable "lambda_delete_name" {
  description = "name of the lambda function"
  type = string
  default = "pattern-movies-delete"

}

variable "apigw_name" {
  description = "name of the lambda function"
  type = string
  default = "bibi-apigw-http-lambda"

}

variable "lambda_log_retention" {
  description = "lambda log retention in days"
  type = number
  default = 7
}

variable "apigw_log_retention" {
  description = "api gwy log retention in days"
  type = number
  default = 7
}