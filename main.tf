locals {
  enabled = module.this.enabled

  # manage quotas that have a `value` defined
  quotas_to_manage         = { for i, quota in var.service_quotas : i => quota if local.enabled && lookup(quota, "value", null) != null }
  quotas_to_manage_by_code = { for i, quota in local.quotas_to_manage : i => quota if local.enabled && lookup(quota, "quota_code", null) != null }
  quotas_to_manage_by_name = { for i, quota in local.quotas_to_manage : i => quota if local.enabled && lookup(quota, "quota_name", null) != null }

  # lookup quotas that have a `quota_code` or `quota_name` defined and `value` is null
  quotas_to_lookup         = { for i, quota in var.service_quotas : i => quota if local.enabled && lookup(quota, "value", null) == null }
  quotas_to_lookup_by_code = { for i, quota in local.quotas_to_lookup : i => quota if local.enabled && lookup(quota, "quota_code", null) != null }
  quotas_to_lookup_by_name = { for i, quota in local.quotas_to_lookup : i => quota if local.enabled && lookup(quota, "quota_name", null) != null }

  # a list of all of the service quotas being managed by this module, used as an output
  service_quotas = [
    for i, v in concat(
      aws_servicequotas_service_quota.managed_by_code[*],
      aws_servicequotas_service_quota.managed_by_name[*],
      data.aws_servicequotas_service_quota.lookup_quota_by_code[*],
      data.aws_servicequotas_service_quota.lookup_quota_by_name[*]
    ) : v if length(v) > 0
  ]
}

# for_each service_quota where `value` is not `null`, try to modify
resource "aws_servicequotas_service_quota" "managed_by_code" {
  for_each = local.quotas_to_manage_by_code

  quota_code   = each.value.quota_code
  service_code = each.value.service_code
  value        = var.service_quotas[each.key].value
}

# find quota codes
data "aws_servicequotas_service_quota" "managed_by_name" {
  for_each = local.quotas_to_manage_by_name

  service_code = each.value.service_code
  quota_name   = each.value.quota_name
}

resource "aws_servicequotas_service_quota" "managed_by_name" {
  for_each = data.aws_servicequotas_service_quota.managed_by_name

  quota_code   = each.value.quota_code
  service_code = each.value.service_code
  value        = var.service_quotas[each.key].value
}

# for_each service_quota where `value` is `null`, lookup service quotas by either `quota_code` or `quota_name`
data "aws_servicequotas_service_quota" "lookup_quota_by_code" {
  for_each = local.quotas_to_lookup_by_code

  quota_code   = each.value.quota_code
  service_code = each.value.service_code
}

data "aws_servicequotas_service_quota" "lookup_quota_by_name" {
  for_each = local.quotas_to_lookup_by_name

  quota_name   = each.value.quota_name
  service_code = each.value.service_code
}
