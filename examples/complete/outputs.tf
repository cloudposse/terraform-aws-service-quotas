output "service_quotas" {
  description = "List of service quotas that are being managed by this module"
  value       = module.service_quotas.service_quotas
}
