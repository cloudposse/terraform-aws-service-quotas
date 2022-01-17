output "service_quotas" {
  description = "List of service quotas that are being managed by this module"
  value       = local.enabled ? local.service_quotas : null
}
