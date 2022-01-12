variable "region" {
  type        = string
  description = "AWS Region"
}

# TODO: use `optional` when it becomes GA
variable "service_quotas" {
  type        = any
  description = <<-EOF
  A list of service quotas to create or lookup. To lookup the value of a service quota, set `value = null`.
  Use `quota_code` to identify the specific quota to interact with.
  EOF
  default     = []
}
