output "service_quotas" {
  description = "List of service quotas that are being managed by this module"
  value = [
    for i, v in concat(
      aws_servicequotas_service_quota.managed_by_code[*],
      aws_servicequotas_service_quota.managed_by_name[*],
      data.aws_servicequotas_service_quota.lookup_quota_by_code[*],
      data.aws_servicequotas_service_quota.lookup_quota_by_name[*]
    ) : v if length(v) > 0
  ]
}
