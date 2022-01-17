module "service_quotas" {
  source = "../../"

  service_quotas = var.service_quotas

  context = module.this.context
}
