variable "aws_region" {
  type        = string
  description = "aws region to create the infra"
}

variable "instance_id" {
  type = string
}

variable "webhook_url" {
  type        = string
  description = "webhook url to send alerts"
}
