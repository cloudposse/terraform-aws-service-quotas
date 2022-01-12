# TODO: use `optional` when it becomes GA
variable "service_quotas" {
  type        = any
  description = <<-EOF
  A list of service quotas to manage or lookup.
  To lookup the value of a service quota, set `value = null` and either `quota_code` or `quota_name`.
  To manage a service quota, set `value` to a number. Service Quotas can only be managed via `quota_code`.
  EOF
  default     = []
}
